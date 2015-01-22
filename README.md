# tinc-cookbook-cookbook

TODO: Enter the cookbook description here.

## Supported Platforms

TODO: List your supported platforms.

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['tinc-cookbook']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### tinc-cookbook::default

Include `tinc-cookbook` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[tinc-cookbook::default]"
  ]
}
```

## License and Authors

Author:: Christophe Courtaut (<christophe.courtaut@gmail.com>)
