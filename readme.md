# zoe

<img width="1966" height="1250" alt="Screenshot 2025-12-07 at 18 50 44" src="https://github.com/user-attachments/assets/3c45fe1a-a852-4070-a79d-f298b1857829" />
<img width="1966" height="1250" alt="Screenshot 2025-12-07 at 18 50 39" src="https://github.com/user-attachments/assets/5e574c4a-73c1-475f-b4e9-9087f24fbe7b" />
<img width="1966" height="1250" alt="Screenshot 2025-12-07 at 18 50 50" src="https://github.com/user-attachments/assets/7ec3bd2b-b281-4a0f-ab66-5d0802e62ede" />

## requirements

- os->{`macos`}
- - version.minimum->{`15.0`};
- - - defaults:to->{`26.0`};
- - - override_with:`target_macos_version`
- - with->{`metal`}.support().version.minimum->{`2.1`};

### frameworks

- `metal`
- `metalkit`
- `gamecontroller`
- `coreaudio`
- `coregraphics`
- `coretext`

## configuration

- path->{`~/.config/zoe`};
- parameter:name->{value}
- - `audio:volume`: `float`
- - `rendering_properties:brightness`: `float`
- - `rendering_properties:brightness_text`: `float`

### example

```
audio:volume->{0.27};
```

## development

### prerequisites

- [`alic3`](https://github.com/alic3dev):libraries
- - [`cer0`](https://github.com/alic3dev/cer0)
- - [`clic3`](https://github.com/alic3dev/clic3)
- - [`interrupt_handler`](https://github.com/alic3dev/interrupt_handler)
- - [`math_c`](https://github.com/alic3dev/math_c)
- - [`metil`](https://github.com/alic3dev/metil)

### assets

```zsh
make pull_assets
```

#### redownload

```zsh
make pull_assets_all
```

### build

```zsh
make
```

#### options

- `codesigning_id`:which_identity_to_use_for_codesigning
- `debug=1`:adds->{`debugging_symbols`}:disables->{`optimizations`};
- `device_identifier`:which_device_to_install_to_or_run_on
- `disable_metal_fast_options=1`:disables->{`metal`::`fast_modes `};
- `provisioning_profile_identifier`:which_provisioning_profile_identifier_to_use_for_signing_entitlements
- `target_device`:sets_the_target_device_platform->{values::[`mac`|`iphone`]}
- `target_device_version`:sets_the_target_version.for->{`macos`|`metal`};
- `target_metal_standard`:sets_the_target_metal_standard::(will_use->{`metal4.0`}_if_not_set)
- `target_metal_version`:sets_the_target_metal_version::(will_use->{`target_device_version`}_if_not_set)

```zsh
parameter=value make
: or
parameter_1=value_1 parameter_2=value_2 make
```

### clean

```zsh
make clean
```

## copyright | copyleft

> © [copyleft|copyright]->{alic3dev:2025}->[all_rights_reserved|all_lefts_reserved]
