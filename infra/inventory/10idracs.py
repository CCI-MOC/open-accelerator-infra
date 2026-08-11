#!/usr/bin/env python3

import json
import os
import sys

import yaml

INVENTORY_FILE = "inventory/00hosts.yaml"


def find_bmc_addrs(data: dict) -> list[str]:
    addrs = []
    if isinstance(data, dict):
        if "bmc_addr" in data:
            addrs.append(data["bmc_addr"])
        for value in data.values():
            addrs.extend(find_bmc_addrs(value))
    return addrs


def main():
    if "--list" not in sys.argv:
        print(json.dumps({}))
        return

    with open(INVENTORY_FILE) as f:
        inventory = yaml.safe_load(f)

    addrs = find_bmc_addrs(inventory)

    print(
        json.dumps(
            {
                "idracs": {
                    "hosts": addrs,
                    "vars": {
                        "ansible_user": "root",
                        "ansible_password": os.environ.get("SSHPASS", ""),
                    },
                },
                "_meta": {
                    "hostvars": {},
                },
            }
        )
    )


if __name__ == "__main__":
    main()
