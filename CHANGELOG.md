# Changelog

1.3.x
-----
* TON SDK version: 1.6.0
* the changes are according the ones of TON SDK

1.2.x
-----
* TON SDK version: 1.5.2
* min Ruby version: 3.0


1.1.x
-----
* new `Client` `.resolve_app_request()`
* new `Net` `.query()`, `.suspend()`, `.resume()`
* new `Debot`
* new `Boc` `.get_boc_hash()`
* new `Crypto` `.register_signing_box()`, `.get_signing_box()`, `.signing_box_get_public_key()`,
`.signing_box_sign()`, `remove_signing_box()`
* new paramentes in `NetworkConfig`; particularly

```
  server_address: "example.com"
```

becomes

```
  endpoints: ["example.com"]
```

check out the main repository for the details

* new data types/classes in several modules


1.0.0
-----
* The first version has been released.