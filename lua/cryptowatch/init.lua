local M = {}

local default_config = {
  pair = "USDT",
  color = { bg = '#3D4E81', fg = '#A9B1D6', gui = 'bold' },
}

local coins = {
  { coin = 'BTC', color = { bg = '#3D4E81', fg = '#A9B1D6', gui = 'bold' } },
  { coin = 'ETH', color = { bg = '#5753C9', fg = '#d6d8df', gui = 'bold' } },
  { coin = 'LTC', color = { bg = '#6E7FF3', fg = '#e2e4e9', gui = 'bold' } },
}
local poll_interval = 1000

local timer

local function get_coin_price(coin_pair)
  require("plenary.job"):new({
    command = "curl",
    args = { "-s", "https://api.binance.com/api/v3/ticker/price?symbol=" .. coin_pair.coin .. coin_pair.pair },
    on_exit = function(j, return_val)
      if return_val == 0 then
        vim.schedule(function()
          local coin_price = vim.fn.json_decode(j:result())["price"]
          coin_price = string.format("%s %.1f", coin_pair.coin, coin_price)
          local coin_name = string.lower(coin_pair.coin)
          vim.g[coin_name .. "_price"] = coin_price
        end)
      else
        print("Failed to retrieve " .. coin_pair.coin .. " price")
      end
    end,
  }):start()
end

function M.setup(opts)
  coins = opts.coins or coins
  poll_interval = opts.poll_interval or poll_interval

  local default_pair = opts.default_pair or default_config.pair
  local default_color = opts.default_color or default_config.color

  for _, coin_pair in ipairs(coins) do
    coin_pair.pair = coin_pair.pair or default_pair
    coin_pair.color = coin_pair.color or default_color
  end

  if timer then
    timer:stop()
  end

  timer = vim.loop.new_timer()
  timer:start(0, poll_interval, function()
    for _, coin_pair in ipairs(coins) do
      get_coin_price(coin_pair)
    end
  end)

  local price_list = {}
  for _, coin_pair in ipairs(coins) do
    table.insert(price_list, {
      function() return vim.g[string.lower(coin_pair.coin) .. "_price"] end,
      color = coin_pair.color
    })
  end

  return price_list
end

return M
