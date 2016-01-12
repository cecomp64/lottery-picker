#!/usr/bin/env ruby

require 'optparse'

def print_hash_list(hl, prefix = '')
  str = "#{prefix}[\n"
  hl.each{|h| str += "#{prefix}  #{h}\n"}
  str += "#{prefix}]"

  return str
end

def parse_opts(print=false)
  options = {}

  optparse = OptionParser.new do |opts|
    opts.banner = 'Usage: lottery_picker.rb'

    opts.on('-h', '--help', 'Show this message') do
      puts opts
      exit(0)
    end

    options[:num_picks] = 10
    opts.on('-n', '--num_picks num', "Number of picks to make.  Default #{options[:num_picks]}") do |num|
      options[:num_picks] = num.to_i
    end

    options[:white_range] = (1..69)
    options[:red_range] = (1..26)

    options[:num_white] = 5
    opts.on('-w', '--num_white num', "Number of white numbers.  Default #{options[:num_white]}") do |num|
      options[:num_red] = num.to_i
    end

    options[:num_red] = 1
    opts.on('-r', '--num_red num', "Number of red numbers.  Default #{options[:num_red]}") do |num|
      options[:num_red] = num.to_i
    end

    options[:max_repeating_wb] = options[:num_white]
    opts.on('-m', '--max_repeating_wb num', 'Define how many white numbers are allowed to be shared among any two picks.  Default reuse any.') do |num|
      options[:max_repeating_wb] = num.to_i
    end

    options[:max_repeating_rb] = options[:num_red]
    opts.on('--max_repeating_rb num', 'Define how many red numbers are allowed to be shared among any two picks.  Default reuse any.') do |num|
      options[:max_repeating_rb] = num.to_i
    end

    options[:previous_picks] = []
    opts.on('-p', '--previous_picks file', 'A data file containing a set of picks to consider in constraints.') do |file|
      fh = File.open(file)
      data = fh.read
      options[:previous_picks] = eval(data)
    end

    options[:prize_mod] = []
    opts.on('--prize_mod file', 'A data file containing the prize information.') do |file|
      fh = File.open(file)
      data = fh.read
      options[:prize_mod] = eval(data)
    end

    options[:lucky_numbers] = []
    opts.on('-l', '--lucky_numbers 1,2,3,...', Array, 'A list of numbers to preference in picking') do |arr|
      options[:lucky_numbers] = arr.map{|a| a.to_i}
    end

    options[:check] = nil
    opts.on('-c', '--check file', 'Specify a data file containing the actual drawing to check your picks against.  Should probably be used with -p') do |file|
      fh = File.open(file)
      data = fh.read
      options[:check] = eval(data)
    end

    options[:num_picks] = 10
    opts.on('-n', '--num_picks num', "Number of picks to make.  Default #{options[:num_picks]}") do |num|
      options[:num_picks] = num.to_i
    end

    options[:data_print] = false
    opts.on('-d', '--data_print', 'Print picks in internal format.  These can be copied into a file and used as input.') do
      options[:data_print] = true
    end

  end

  optparse.parse!

  # Error checking
  if(options[:max_repeating_wb] == 0 && options[:white_range].max < options[:num_picks])
    puts "[E] Requested more picks with unique white numbers than there are total numbers! white_range: #{options[:white_range]}, num_picks: #{options[:num_picks]}"
    exit(1)
  end

  if(options[:max_repeating_rb] == 0 && options[:red_range].max < options[:num_picks])
    puts "[E] Requested more picks with unique red numbers than there are total numbers! red_range: #{options[:red_range]}, num_picks: #{options[:num_picks]}"
    exit(1)
  end
  if(print)
    puts 'Running With Options:'
    options.each do |k,v|
      vstr = v
      if(k == :previous_picks && v.size > 0)
        vstr = "\n#{print_hash_list(v, '  ')}"
      end
      puts "  #{k}: #{vstr}"
    end
  end
end

def print_money(val)
  "$#{val.to_s.reverse.scan(/.{1,3}/).reverse.map{|s| s.reverse}.join(',')}"
end

class Result
  attr_accessor :pick, :drawing, :kind, :value
  RESULTS = {
      LOSER: {rb_matches: 0, wb_matches: 0, str: 'Loser', value: 0},
      W5R1: {rb_matches: 1, wb_matches: 5, str: 'Grand Prize Winner!', value: 900000000},
      W5R0: {rb_matches: 0, wb_matches: 5, str: 'Second Place Winner!', value: 1000000},
      W4R1: {rb_matches: 1, wb_matches: 4, str: 'Third Place Winner!', value: 50000},
      W4R0: {rb_matches: 0, wb_matches: 4, str: 'Fourth Place Winner!', value: 100},
      W3R1: {rb_matches: 1, wb_matches: 3, str: 'Fifth Place Winner!', value: 100},
      W3R0: {rb_matches: 0, wb_matches: 3, str: 'Sixth Place Winner!', value: 7},
      W2R1: {rb_matches: 1, wb_matches: 2, str: 'Seventh Place Winner!', value: 7},
      W1R1: {rb_matches: 1, wb_matches: 1, str: 'Eighth Place Winner!', value: 4},
      W0R1: {rb_matches: 1, wb_matches: 0, str: 'Ninth Place Winner!', value: 4},
  }

  def initialize(pick, drawing, new_values = {})
    self.pick = pick
    self.drawing = drawing
    self.kind = :LOSER
    new_values.each{|k,v| RESULTS[k][:value] = v}
    compute_result
    compute_value
  end

  def compute_result
    rb_matches = (pick[:rb] == drawing[:rb]) ? 1 : 0
    wb_matches = 0
    # Count the number of white matches
    pick[:wb].each do |picked_num|
      wb_matches = wb_matches+1 if(drawing[:wb].include?(picked_num))
    end

    RESULTS.each do |k,v|
      self.kind = k if(v[:rb_matches] == rb_matches && v[:wb_matches] == wb_matches)
    end
  end

  def compute_value
    mul = (drawing[:multiplier]) || 1
    # 1st and second place are special case
    if(kind == :W5R1)
       self.value = RESULTS[kind][:value]
    elsif (kind == :W5R0 && mul > 1)
      self.value = (2 * RESULTS[kind][:value])
    else
      self.value = (mul * RESULTS[kind][:value])
    end
  end

  def winner?
    return true if(kind != :LOSER)
    return false
  end

  def to_s
    return RESULTS[kind][:str]
  end
end

class LotteryPicker
  def self.text_to_data(file)

    hash = {}
    keys = []

    File.open(file) do |fh|
      fh.each_line do |line|
        if(line =~ /Draw Date/)
          keys = line.split(' ')
        else
          data = line.split(' ')
          keys.each_with_index do |k,i|
            hash[k] = data[i]
          end
        end
      end
    end
  end

  def self.number_picker(options)
    wb_range = options[:white_range]
    pb_range = options[:red_range]
    num_wb = options[:num_white]
    num_rb = options[:num_red]
    reuse_rb = num_rb == options[:max_repeating_rb] # TODO: Treat rb as an array
    input_numbers = options[:previous_picks]
    wbl = options[:lucky_numbers]
    number_of_picks = options[:num_picks]

    epicks = []
    new_picks = []

    # initialize picks with external picks
    input_numbers.each{|inp| epicks << inp}

    while(new_picks.size < number_of_picks)
      pick = {wb: [], rb: 0}
      is_unique = false

      # Separate out red from white
      while(!is_unique)
        pick[:rb] = rand(pb_range)
        is_unique = reuse_rb ? true : !epicks.map{|p| p[:rb]}.include?(pick[:rb])
        #puts "DBG: rb #{pick[:rb]} is_unique? #{is_unique} arr: #{epicks.map{|p| p[:rb]}}"
      end

      is_unique = false
      white_tries = 0
      while(!is_unique)
        pick[:wb] = []
        # Use lucky numbers if specified
        wb_list = (wbl.size == 0) ? Array(wb_range) : wbl.dup

        # TODO: special case 0 repeated numbers

        # Pick n numbers
        num_wb.times do
          num = wb_list[rand(wb_list.size)]
          pick[:wb] << num
          wb_list.delete(num)
        end

        num_repeated = 0
        is_unique = true

        # Check uniqueness
        epicks.map{|p| p[:wb]}.each do |wb_arr|
          wb_arr.each do |picked_wb|
            num_repeated = num_repeated+1 if(pick[:wb].include?(picked_wb))
          end
          is_unique = is_unique && (num_repeated <= options[:max_repeating_wb])
          num_repeated = 0
        end

        white_tries += 1
      end

      pick[:wb].sort!
      new_picks << pick
      epicks << pick
      #puts "DBG: is_unique #{is_unique} num_repeated: #{num_repeated} max #{options[:max_repeating_wb]}"
    end

    return new_picks
  end

  # pick_one
  #
  # Make picks without repeating individual numbers too often
  def self.pick_one(frequency_arr, max_frequency)
    # Maintain frequency_arr as a 2-D array.  First dimension is number of times picked
    # Second dimension is the numbers that have been picked that many times.
    # Flatten out the array to randomly pick a number
    choices = frequency_arr[0...-1].flatten
    # Move the chosen number into the next frequency list
  end

  def self.check_picks(picks, drawing, prize_mod = {})
    results = []
    # Check for winners
    picks.each do |pick|
      results << Result.new(pick, drawing, prize_mod)
    end

    return results
  end

  def self.print_picks(picks, pretty=true)
    if(pretty)
      picks.each do |pick|
        puts "WB: #{pick[:wb].join("\t")}\t RB: #{pick[:rb]}"
      end
    else
      puts print_hash_list picks
    end
  end
end

if(__FILE__==$0)
  options = parse_opts(true)

  puts "\nComputing picks...\n\n"
  picks = LotteryPicker.number_picker options
  all_picks = picks + options[:previous_picks]

  if(options[:previous_picks].size > 0)
    puts 'Previous Picks'
    puts '--------------'
    LotteryPicker.print_picks(options[:previous_picks], !options[:data_print])
  end

  if(picks.size > 0)
    puts 'Computed Picks'
    puts '--------------'
    LotteryPicker.print_picks(picks, !options[:data_print])
  end

  if(options[:check])
    results = LotteryPicker.check_picks(all_picks, options[:check], options[:prize_mod])
    total = 0
    puts "\nResults for drawing: #{options[:check]}"
    results.each do |result|
      puts "  Pick: #{result.pick}\t\t Result: #{result}\t\t Value: #{print_money result.value}#{result.winner? ? ' +++ WINNER +++' : ''}"
      total += result.value
    end

    puts "\nTotal Winnings: #{print_money total}"
  end
end
