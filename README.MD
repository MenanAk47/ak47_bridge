Here is a comprehensive documentation file in Markdown format for the **ak47_bridge** resource.

---

# Ak47 Bridge Documentation

**ak47_bridge** is a unified compatibility layer designed to support multiple FiveM frameworks (ESX, QBCore, QBX) and various third-party resources (Inventory, Target, Fuel, etc.) through a single, consistent API. This allows developers to write scripts that work across different server setups without writing complex adaptation code.

## 🌟 Features

* **Multi-Framework Support:** Auto-detects and bridges ESX, QBCore, and QBX.
* **Unified API:** Consistent function calls for Player, Economy, Inventory, and Vehicle management.
* **Auto-Detection:** Automatically configures itself based on started resources (Configurable to 'auto').
* **Extensive Integrations:** Built-in support for popular inventories, fuel scripts, garages, and target systems.
* **Developer Friendly:** Simplifies dependency management for paid or free releases.

## 📋 Requirements

* **FiveM Server** (Artifacts enabling Lua 5.4 recommended)
* **[ox_lib](https://github.com/overextended/ox_lib)** (Required for UI, callbacks, and utilities)
* **A Supported Framework:**
* ESX Legacy
* QBCore
* QBX Core



## 📦 Installation

1. Download the `ak47_bridge` resource.
2. Place the folder into your server's `resources` directory.
3. Ensure `ox_lib` is started **before** the bridge.
4. Add the following to your `server.cfg`:
```cfg
ensure ox_lib
ensure ak47_bridge

```



## ⚙️ Configuration

The configuration is handled in `config.lua`. By default, most options are set to `'auto'`, meaning the bridge will scan your server resources and select the appropriate integration automatically.

```lua
Config = {}

-- Framework: 'esx', 'qb', 'qbx', 'auto'
Config.Framework = 'auto'

-- Notification System: 'ox', 'esx', 'qb', 'qbx', 'custom'
Config.Notify = 'ox'

-- Progress Bar: 'ox', 'esx', 'qb', 'custom'
Config.Progressbar = 'ox'

-- Garage System: 'ak47_garage', 'cd_garage', 'qb-garages', etc.
Config.Garage = 'auto'

-- Vehicle Keys: 'ak47_vehiclekeys', 'wasabi_carlock', 'qs-vehiclekeys', etc.
Config.VehicleKey = 'auto'

-- Fuel System: 'LegacyFuel', 'ox_fuel', 'ps-fuel', etc.
Config.FuelScript = 'auto'

-- Inventory: 'ox_inventory', 'qs-inventory', 'qb-inventory', etc.
Config.Inventory = 'auto'

-- Banking: 'qb-banking', 'okokBanking', 'Renewed-Banking'
Config.Banking = 'auto'

```

---

## 📚 API Reference

To use the bridge in your resource, you can access the exported `Bridge` object.

* **Lua Import:** `local Bridge = exports['ak47_bridge']:GetBridge()`

### 👤 Player Management (Server)

| Function | Arguments | Returns | Description |
| --- | --- | --- | --- |
| `Bridge.GetPlayer` | `source` | `object` | Returns the raw Framework player object (xPlayer/Player). |
| `Bridge.GetIdentifier` | `source` | `string` | Returns the player's unique identifier (CitizenID or Identifier). |
| `Bridge.GetName` | `source` | `string` | Returns the player's full name. |
| `Bridge.GetPhoneNumber` | `source` | `string` | Returns the player's phone number. |
| `Bridge.GetJob` | `source` | `table` | Returns a standardized job table `{name, label, payment, isboss, grade = {name, level}}`. |
| `Bridge.SetJob` | `source, job, grade` | `void` | Sets the player's job and grade. |
| `Bridge.GetGang` | `source` | `table` | Returns gang data `{name, label, isboss, grade = {level, name}}`. |
| `Bridge.SetGang` | `source, gang, grade` | `void` | Sets the player's gang and grade. |
| `Bridge.IsAdmin` | `source` | `boolean` | Checks if the player has admin permissions (ace allowed 'command'). |
| `Bridge.GetPlayerMetaValue` | `source, key` | `value` | Retrieves metadata (QB/QBX) or ESX xPlayer meta. |
| `Bridge.SetPlayerMetaValue` | `source, key, value` | `void` | Sets metadata for the player. |

### 💰 Economy (Server)

| Function | Arguments | Returns | Description |
| --- | --- | --- | --- |
| `Bridge.GetMoney` | `source, account` | `number` | Get balance. Account: `'money'`/`'cash'`, `'bank'`, etc. |
| `Bridge.AddMoney` | `source, account, amount` | `void` | Add money to specific account. |
| `Bridge.RemoveMoney` | `source, account, amount` | `void` | Remove money from specific account. |
| `Bridge.GetSocietyMoney` | `job` | `number` | Get the balance of a society/boss account. |
| `Bridge.AddSocietyMoney` | `job, amount` | `void` | Add money to a society account. |
| `Bridge.RemoveSocietyMoney` | `job, amount` | `void` | Remove money from a society account. |

### 🎒 Inventory (Server)

Supports: *ox_inventory, qs-inventory, qb-inventory, ps-inventory, ak47_inventory, codem-inventory, and more.*

| Function | Arguments | Returns | Description |
| --- | --- | --- | --- |
| `Bridge.GetInventoryItems` | `inventoryId` | `table` | Returns all items in a specific inventory. |
| `Bridge.GetInventoryItem` | `source, item` | `number` | Returns the count/amount of a specific item a player has. |
| `Bridge.HasEnoughItem` | `source, item, amount` | `boolean` | Checks if player has at least `amount` of `item`. |
| `Bridge.CanCarryItem` | `source, item, amount` | `boolean` | Checks if player has weight/space for item. |
| `Bridge.AddItem` | `source, item, count, slot, meta` | `boolean` | Adds an item to the player's inventory. |
| `Bridge.RemoveItem` | `source, item, count` | `boolean` | Removes an item from the player's inventory. |
| `Bridge.CreateUseableItem` | `item, callback` | `void` | Registers a usable item. |

### 🚗 Vehicles (Server)

| Function | Arguments | Returns | Description |
| --- | --- | --- | --- |
| `Bridge.IsVehicleOwner` | `source, plate` | `boolean` | Checks if the player owns the vehicle with the given plate. |
| `Bridge.GetVehicleOwner` | `plate` | `identifier` | Returns the identifier of the vehicle owner. |
| `Bridge.GeneratePlate` | `format, prefix` | `string` | Generates a unique plate string (e.g., "AAAA 1111"). |
| `Bridge.GiveVehicle` | `source, model` | `void` | Adds a vehicle to the database (owned_vehicles/player_vehicles). |

### 🖥️ Client Utilities & Integrations

#### Status & Ambulance

| Function | Description |
| --- | --- |
| `Bridge.IsDead(target)` | Returns `true` if target (or self if nil) is dead. Checks metadata and animations. |
| `Bridge.IsLastStand(target)` | Returns `true` if target is in last stand/downed state. |
| `Bridge.IsIncapacitated(target)` | Returns `true` if dead or in last stand. |

#### Interactions

| Function | Description |
| --- | --- |
| `Bridge.Notify(msg, type, duration)` | Sends a notification (Support: Ox, ESX, QB, QBX). |
| `Bridge.ShowProgress(data, successCb, cancelCb)` | Displays a progress bar (Support: Ox, ESX, QB). |
| `Bridge.SetVehicleFuel(veh, amount)` | Sets fuel level using the detected fuel script. |
| `Bridge.GiveVehicleKey(plate, veh, virtual)` | GIves keys to the player (Support: wasabi, qs, ak47, qb). |
| `Bridge.RemoveVehicleKey(plate, veh, virtual)` | Removes keys from the player. |
| `Bridge.OpenGarageHousing(garageId)` | Opens garage menu for housing scripts. |
| `Bridge.StoreVehicleHousing(garageId, veh)` | Stores vehicle in housing garage. |

#### Target System (PolyZone/Target Bridge)

Maps generic target calls to **ox_target**, **qb-target**, or **qtarget**.

* `Bridge.AddBoxZone(name, coords, length, width, options, targetOptions)`
* `Bridge.AddCircleZone(name, coords, radius, options, targetOptions)`
* `Bridge.AddPolyZone(name, points, options, targetOptions)`
* `Bridge.AddTargetEntity(entities, options)`
* `Bridge.AddTargetModel(models, options)`
* `Bridge.AddGlobalPed(options)`
* `Bridge.AddGlobalVehicle(options)`
* `Bridge.RemoveZone(id)`

## 🤝 Supported Third-Party Resources

**Inventory:**

* `ox_inventory`
* `qb-inventory` / `ps-inventory` / `lj-inventory`
* `qs-inventory`
* `ak47_inventory` / `ak47_qb_inventory`
* `codem-inventory`
* `tgiann-inventory`
* `origen_inventory`

**Garages:**

* `cd_garage`
* `okokGarage`
* `jg-advancedgarages`
* `loaf_garage`
* `qb-garages` / `qbx_garages`
* `ak47_garage`

**Fuel:**

* `LegacyFuel`
* `ox_fuel`
* `ps-fuel`
* `rcore_fuel`

**Vehicle Keys:**

* `wasabi_carlock`
* `qs-vehiclekeys`
* `qb-vehiclekeys`
* `ak47_vehiclekeys`

## 📄 License

This project is licensed under the [GNU General Public License v3.0](https://www.google.com/search?q=LICENSE).