#!/usr/bin/env python3
"""Ensure all sub-issues of OAC epics are assigned to the correct milestone.

For each issue labeled "epic" whose title starts with "OAC: ", this script:
1. Derives the milestone name by stripping the "OAC: " prefix.
2. Creates the milestone if it doesn't already exist.
3. Assigns the milestone to the epic and all its sub-issues.

Requires the `gh` CLI to be installed and authenticated.
"""

import argparse
import json
import subprocess
import sys

REPO = "CCI-MOC/moc-issues"
PREFIX = "OAC: "
LABEL = "open-accelerator"


def gh(*args: str, input: str | None = None) -> str:
    result = subprocess.run(
        ["gh", *args],
        capture_output=True,
        text=True,
        input=input,
    )
    if result.returncode != 0:
        print(f"gh command failed: gh {' '.join(args)}", file=sys.stderr)
        print(result.stderr, file=sys.stderr)
        sys.exit(1)
    return result.stdout.strip()


def get_epics() -> list[dict]:
    query = """
    query($cursor: String) {
      repository(owner: "CCI-MOC", name: "moc-issues") {
        issues(
          labels: ["epic"],
          first: 100,
          after: $cursor,
          filterBy: {states: [OPEN, CLOSED]}
        ) {
          pageInfo { hasNextPage endCursor }
          nodes {
            number
            title
            milestone { title }
            labels(first: 50) { nodes { name } }
            subIssues(first: 50) {
              nodes {
                number
                title
                milestone { title }
                labels(first: 50) { nodes { name } }
                repository { nameWithOwner }
              }
            }
          }
        }
      }
    }
    """
    raw = gh("api", "graphql", "-f", f"query={query}")
    data = json.loads(raw)
    issues = data["data"]["repository"]["issues"]["nodes"]
    return [i for i in issues if i["title"].startswith(PREFIX)]


def get_milestones() -> dict[str, int]:
    raw = gh(
        "api",
        f"repos/{REPO}/milestones",
        "--paginate",
        "--jq",
        ".[] | [.number, .title] | @tsv",
    )
    result: dict[str, int] = {}
    for line in raw.splitlines():
        if not line.strip():
            continue
        num, title = line.split("\t", 1)
        result[title] = int(num)
    return result


def create_milestone(title: str) -> int:
    raw = gh(
        "api",
        f"repos/{REPO}/milestones",
        "-f",
        f"title={title}",
        "--jq",
        ".number",
    )
    return int(raw)


def add_label(issue_number: int, label: str) -> None:
    gh(
        "api",
        f"repos/{REPO}/issues/{issue_number}/labels",
        "--input",
        "-",
        input=json.dumps({"labels": [label]}),
    )


def set_milestone(issue_number: int, milestone_number: int) -> None:
    gh(
        "api",
        f"repos/{REPO}/issues/{issue_number}",
        "-X",
        "PATCH",
        "-f",
        f"milestone={milestone_number}",
        "--silent",
    )


def parse_args():
    p = argparse.ArgumentParser()
    p.add_argument("--dry-run", "-n", action="store_true", default=False)
    return p.parse_args()


def main() -> None:
    args = parse_args()

    if args.dry_run:
        print("=== DRY RUN (no changes will be made) ===\n")

    epics = get_epics()
    if not epics:
        print("No OAC epics found.")
        return

    milestones = get_milestones()
    changes = 0

    for epic in sorted(epics, key=lambda e: e["number"]):
        milestone_name = epic["title"].removeprefix(PREFIX)
        print(f"Epic #{epic['number']}: {epic['title']}")
        print(f"  Milestone: {milestone_name}")

        if milestone_name not in milestones:
            if args.dry_run:
                print(f"  Would create milestone: {milestone_name}")
            else:
                milestones[milestone_name] = create_milestone(milestone_name)
                print(f"  Created milestone: {milestone_name}")

        ms_num = milestones.get(milestone_name)

        all_issues = [
            (epic["number"], epic["title"], epic["milestone"], epic["labels"]),
        ]
        for sub in epic["subIssues"]["nodes"]:
            if sub["repository"]["nameWithOwner"].lower() != REPO.lower():
                print(
                    f"  Skipping #{sub['number']} ({sub['title']}): "
                    f"in {sub['repository']['nameWithOwner']}"
                )
                continue
            all_issues.append(
                (sub["number"], sub["title"], sub["milestone"], sub["labels"])
            )

        for issue_num, issue_title, current_ms, labels in all_issues:
            current_name = current_ms["title"] if current_ms else None
            has_label = any(lb["name"] == LABEL for lb in labels["nodes"])

            if current_name == milestone_name and has_label:
                print(f"  #{issue_num}: OK")
                continue

            if current_name != milestone_name:
                changes += 1
                if current_name:
                    action = f"change milestone {current_name!r} -> {milestone_name!r}"
                else:
                    action = f"set milestone to {milestone_name!r}"

                if args.dry_run:
                    print(f"  #{issue_num}: WOULD {action}")
                else:
                    assert ms_num is not None
                    set_milestone(issue_num, ms_num)
                    print(f"  #{issue_num}: {action}")

            if not has_label:
                changes += 1
                if args.dry_run:
                    print(f"  #{issue_num}: WOULD add label {LABEL!r}")
                else:
                    add_label(issue_num, LABEL)
                    print(f"  #{issue_num}: added label {LABEL!r}")

        print()

    if changes == 0:
        print("All issues already have the correct milestone.")
    elif args.dry_run:
        print(f"{changes} issue(s) would be updated. Run without --dry-run to apply.")
    else:
        print(f"{changes} issue(s) updated.")


if __name__ == "__main__":
    main()
