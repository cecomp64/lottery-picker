#!/usr/bin/env ruby

require_relative '../lottery_picker'
lg_picks =  [
    {wb: [4,21,38,52,61], rb: 25},
    {wb: [3,9,21,28,36], rb: 11},
    {wb: [11,28,43,44,58], rb: 23},
    {wb: [6,8,20,37,64], rb: 22},
    {wb: [16,26,27,50,52], rb: 14},
    {wb: [2,29,40,47,66], rb: 10},
    {wb: [16,12,30,62,69], rb: 17},
    {wb: [32,42,56,65,68], rb: 21},
    {wb: [3,17,20,67,55], rb: 13},
]

options = {
    num_white: 5,
    num_red: 1,
    num_picks: 10,
    max_repeating_wb: 4,
    max_repeating_rb: 1,
    white_range: (1..69),
    red_range: (1..26),
    previous_picks: lg_picks,
    lucky_numbers: []
}

ce_picks = LotteryPicker.number_picker(options)
options[:num_picks] = 7
options[:previous_picks] += ce_picks
anya_picks = LotteryPicker.number_picker(options)

puts "LG Picks"
puts "--------"
LotteryPicker.print_picks(lg_picks)

puts "CE Picks"
puts "--------"
LotteryPicker.print_picks(ce_picks)

puts "Anya Picks"
puts "--------"
LotteryPicker.print_picks(anya_picks)

results = LotteryPicker.check_picks(lg_picks + ce_picks + anya_picks, {wb: [16, 19, 32, 34, 57], rb: 13, value: 900000000, multiplier: 3})
results.each do |result|
  puts "  Pick: #{result.pick}\t\t Result: #{result}\t\t Value: #{print_money result.value}#{result.winner? ? ' +++ WINNER +++' : ''}"
end
