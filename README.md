# cryptowatch.nvim

`cryptowatch.nvim` is a Neovim plugin that allows users to monitor the latest prices of popular cryptocurrencies directly within Neovim. 

## Features

- Monitor multiple cryptocurrencies.
- Customize the list of cryptocurrencies and trading pairs to watch.
- Set custom colors for each cryptocurrency.
- Set custom polling interval to update prices.
- Set default trading pair and color.
- Easy integration with lualine.

## Installation

You can use your favorite plugin manager to install `cryptowatch.nvim`. 

#### vim-plug:

```
Plug 'Hzzy2O/cryptowatch.nvim'
```

#### packer:
```
use 'Hzzy2O/cryptowatch.nvim'
```

## Usage

Here's a simple example of how to use `cryptowatch.nvim` and integrate it with lualine:

\`\`\`lua
local cryptowatch = require'cryptowatch'

local price_list = cryptowatch.setup({
  pairs = {
    { coin = 'BTC' },
    { coin = 'ETH' },
    { coin = 'LTC' },
  },
  default_pair = "USDT",
  default_color = { bg = '#3D4E81', fg = '#A9B1D6', gui = 'bold' },
  poll_interval = 1000 -- in milliseconds
})

require('lualine').setup({
  sections = {
    lualine_z = price_list
  }
})
\`\`\`

## Configuration

Here's a description of the options you can set in the `setup` function:

- `pairs`: A table containing the list of cryptocurrencies and trading pairs to monitor. You can specify the `coin`, `pair`, and `color` for each entry. Defaults to `{"BTC", "ETH", "LTC"}` with the default pair "USDT" and default color.
- `default_pair`: The default trading pair to use if not specified in the `pairs` table. Defaults to `"USDT"`.
- `default_color`: The default color to use if not specified in the `pairs` table. See the Usage section for the format.
- `poll_interval`: The polling interval to update prices in milliseconds. Defaults to `1000`.
