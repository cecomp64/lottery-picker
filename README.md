# Lottery Picker

## Usage

```
$ ./lottery_picker.rb -h
Usage: lottery_picker.rb
    -h, --help                       Show this message
    -w, --num_white num              Number of white numbers.  Default 5
    -r, --num_red num                Number of red numbers.  Default 1
    -m, --max_repeating_wb num       Define how many white numbers are allowed to be shared among any two picks.  Default reuse any.
        --max_repeating_rb num       Define how many red numbers are allowed to be shared among any two picks.  Default reuse any.
    -p, --previous_picks file        A data file containing a set of picks to consider in constraints.
        --prize_mod file             A data file containing the prize information.
    -l, --lucky_numbers 1,2,3,...    A list of numbers to preference in picking
    -c, --check file                 Specify a data file containing the actual drawing to check your picks against.  Should probably be used with -p
    -n, --num_picks num              Number of picks to make.  Default 10
    -d, --data_print                 Print picks in internal format.  These can be copied into a file and used as input.
```

## Checking Your Picks
```
$ ./lottery_picker.rb -c sample_data/drawing.rb -n 0 -p sample_data/picks.rb --prize_mod sample_data/ca_prizes_1_9_2016.rb  -d

Computing picks...

Previous Picks
--------------
[
  {:wb=>[4, 21, 38, 52, 61], :rb=>25}
  {:wb=>[3, 9, 21, 28, 36], :rb=>11}
  {:wb=>[11, 28, 43, 44, 58], :rb=>23}
  {:wb=>[6, 8, 20, 37, 64], :rb=>22}
  {:wb=>[16, 26, 27, 50, 52], :rb=>14}
  {:wb=>[2, 29, 40, 47, 66], :rb=>10}
  {:wb=>[16, 12, 30, 62, 69], :rb=>17}
  {:wb=>[32, 42, 56, 65, 68], :rb=>21}
  {:wb=>[3, 17, 20, 67, 55], :rb=>13}
  {:wb=>[26, 23, 3, 34, 60], :rb=>9}
  {:wb=>[11, 51, 8, 35, 58], :rb=>3}
  {:wb=>[22, 5, 45, 21, 24], :rb=>18}
  {:wb=>[9, 30, 55, 34, 12], :rb=>4}
  {:wb=>[25, 32, 40, 38, 37], :rb=>19}
  {:wb=>[61, 30, 33, 56, 39], :rb=>24}
  {:wb=>[27, 46, 48, 45, 17], :rb=>12}
  {:wb=>[14, 43, 41, 32, 55], :rb=>16}
  {:wb=>[19, 1, 63, 28, 27], :rb=>1}
  {:wb=>[5, 7, 54, 48, 35], :rb=>6}
  {:wb=>[61, 58, 57, 59, 22], :rb=>8}
  {:wb=>[39, 56, 60, 23, 10], :rb=>7}
  {:wb=>[47, 64, 42, 50, 25], :rb=>15}
  {:wb=>[40, 67, 4, 44, 15], :rb=>20}
  {:wb=>[59, 65, 31, 22, 1], :rb=>5}
  {:wb=>[8, 49, 6, 69, 10], :rb=>2}
  {:wb=>[24, 57, 33, 35, 13], :rb=>26}
  {:wb=>[16, 19, 32, 34, 57], :rb=>12}
]

Results for drawing: {:wb=>[16, 19, 32, 34, 57], :rb=>13, :value=>900000000, :multiplier=>3}
  Pick: {:wb=>[4, 21, 38, 52, 61], :rb=>25}		 Result: Loser		 Value: $0
  Pick: {:wb=>[3, 9, 21, 28, 36], :rb=>11}		 Result: Loser		 Value: $0
  Pick: {:wb=>[11, 28, 43, 44, 58], :rb=>23}		 Result: Loser		 Value: $0
  Pick: {:wb=>[6, 8, 20, 37, 64], :rb=>22}		 Result: Loser		 Value: $0
  Pick: {:wb=>[16, 26, 27, 50, 52], :rb=>14}		 Result: Loser		 Value: $0
  Pick: {:wb=>[2, 29, 40, 47, 66], :rb=>10}		 Result: Loser		 Value: $0
  Pick: {:wb=>[16, 12, 30, 62, 69], :rb=>17}		 Result: Loser		 Value: $0
  Pick: {:wb=>[32, 42, 56, 65, 68], :rb=>21}		 Result: Loser		 Value: $0
  Pick: {:wb=>[3, 17, 20, 67, 55], :rb=>13}		 Result: Ninth Place Winner!		 Value: $9 +++ WINNER +++
  Pick: {:wb=>[26, 23, 3, 34, 60], :rb=>9}		 Result: Loser		 Value: $0
  Pick: {:wb=>[11, 51, 8, 35, 58], :rb=>3}		 Result: Loser		 Value: $0
  Pick: {:wb=>[22, 5, 45, 21, 24], :rb=>18}		 Result: Loser		 Value: $0
  Pick: {:wb=>[9, 30, 55, 34, 12], :rb=>4}		 Result: Loser		 Value: $0
  Pick: {:wb=>[25, 32, 40, 38, 37], :rb=>19}		 Result: Loser		 Value: $0
  Pick: {:wb=>[61, 30, 33, 56, 39], :rb=>24}		 Result: Loser		 Value: $0
  Pick: {:wb=>[27, 46, 48, 45, 17], :rb=>12}		 Result: Loser		 Value: $0
  Pick: {:wb=>[14, 43, 41, 32, 55], :rb=>16}		 Result: Loser		 Value: $0
  Pick: {:wb=>[19, 1, 63, 28, 27], :rb=>1}		 Result: Loser		 Value: $0
  Pick: {:wb=>[5, 7, 54, 48, 35], :rb=>6}		 Result: Loser		 Value: $0
  Pick: {:wb=>[61, 58, 57, 59, 22], :rb=>8}		 Result: Loser		 Value: $0
  Pick: {:wb=>[39, 56, 60, 23, 10], :rb=>7}		 Result: Loser		 Value: $0
  Pick: {:wb=>[47, 64, 42, 50, 25], :rb=>15}		 Result: Loser		 Value: $0
  Pick: {:wb=>[40, 67, 4, 44, 15], :rb=>20}		 Result: Loser		 Value: $0
  Pick: {:wb=>[59, 65, 31, 22, 1], :rb=>5}		 Result: Loser		 Value: $0
  Pick: {:wb=>[8, 49, 6, 69, 10], :rb=>2}		 Result: Loser		 Value: $0
  Pick: {:wb=>[24, 57, 33, 35, 13], :rb=>26}		 Result: Loser		 Value: $0
  Pick: {:wb=>[16, 19, 32, 34, 57], :rb=>12}		 Result: Second Place Winner!		 Value: $1,558,528 +++ WINNER +++

Total Winnings: $1,558,537
```

