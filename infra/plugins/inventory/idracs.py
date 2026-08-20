from ansible.inventory.helpers import get_group_vars
from ansible.plugins.inventory import BaseInventoryPlugin
from ansible.utils.vars import combine_vars

DOCUMENTATION = """
    name: idracs
    plugin_type: inventory
    short_description: Creates iDRAC hosts from bmc_addr variables
    description:
        - Scans existing inventory for hosts with bmc_type == 'idrac'
          and creates corresponding iDRAC management hosts using their
          bmc_addr values.
"""


class InventoryModule(BaseInventoryPlugin):
    NAME = "idracs"

    def verify_file(self, path):
        return super().verify_file(path) and path.endswith((".yaml", ".yml"))

    def parse(self, inventory, loader, path, cache=True):
        super().parse(inventory, loader, path, cache)

        group = self.inventory.add_group("idracs")

        for host in list(self.inventory.hosts):
            host_obj = self.inventory.get_host(host)
            merged_vars = combine_vars(
                get_group_vars(host_obj.get_groups()), host_obj.get_vars()
            )

            if merged_vars.get("bmc_type") == "idrac":
                bmc_addr = merged_vars.get("bmc_addr")
                if bmc_addr:
                    self.inventory.add_host(bmc_addr, group)
                    self.inventory.set_variable(
                        bmc_addr,
                        "ansible_user",
                        merged_vars.get("bmc_user"),
                    )
                    self.inventory.set_variable(
                        bmc_addr,
                        "ansible_password",
                        merged_vars.get("bmc_password"),
                    )
