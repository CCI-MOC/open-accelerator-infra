# So you want access to the open-accelerator environment...

## Requesting access

Create a pull request that adds your wireguard and ssh public keys to the `people/` directory:

- Ssh public keys should be placed in `people/<yourname>/ssh-keys`.
- Wireguard public keys should be placed in `people/<yourname>/wireguard-keys`.

Submit the pull request and tag @larsks as a reviewer.

### How do I create a wireguard public key?

If you're on Linux, you will first need to install the `wireguard-tools` package. Then run the following command:

```sh
wg genkey | tee wg.private | wg pubkey > wg.public
```

You will use the private key locally when configuring your VPN connection. Add your public key to this repository.
