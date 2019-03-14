require "yaml"
class Hangman
  def initialize
    puts "What do you want to do?\n1)New game\n2)Load game\nIf you want to save your game, simply write 'save'"
    input = gets.chomp
    if input == "1"
      self.get_random_word
      self.check_random_word
    elsif input == "2"
      self.load_game
    elsif input == "save"
      self.save_game
    end
  end

  def get_random_word
    filename = "desk.txt"
    file = File.open(filename, "r+")
    @array = Array.new

    file.each do |line|
      line = line.gsub("\r\n", "")
      @array << line
    end
  end

  def random_word
    @array = @array.sample(1)
    @rand_word = "'#{@array.join("','")}'"
    @rand_word = @rand_word[1..-2]
    @rand_word = @rand_word.downcase
    puts "#{@rand_word}"

    @ar = []
    @rand_word.size.times do
      @ar << "_"
    end
    puts "#{@ar}"

    @used_letters = []
  end

  def check_random_word
    self.random_word
    if @rand_word.size < 13 && @rand_word.size > 6
      self.num_of_guesses
    end
  end

  def give_letter
    puts "Letter:"
    @letter = gets.downcase.chomp
    if @letter == "save"
      self.save_game
    end
  end

  def used_letters
    if @letter.size < 2
      @used_letters << @letter
    end
    puts "Letters used: #{@used_letters}"
  end

  def guess_letters
    self.give_letter
    self.used_letters
    if @rand_word.include? @letter
      arry = @rand_word.split("")
      for i in 0..arry.size
        if arry[i] == @letter
          @ar[i] = arry[i]
        end
      end
    end
    puts "#{@ar}"
  end

  def num_of_guesses
    @num_of_guesses = 0
    (@rand_word.size + 5).times do
      self.guess_letters
      @num_of_guesses = @num_of_guesses + 1
      if @rand_word.split("") == @ar
        puts "YOU WIN"
        return
      end
      if @num_of_guesses == @rand_word.size + 5
        puts "YOU LOSE"
        return
      end
      puts "#{(@rand_word.size + 5) - @num_of_guesses} guesses left"
    end
  end

  def save_game
    puts "Save as:"
    saved_game = gets.chomp.downcase
    Dir.mkdir("saved_games") unless Dir.exists?("saved_games")
    filename = "saved_games/#{saved_game}"
    data = YAML.dump(self)
    File.open(filename, 'w') do |file|
      file.puts data
    end
    puts "Do you want to leave\nY/n"
    leave_game = gets.chomp.downcase
    if leave_game == "y"
      exit
    end
  end

  def load_game
    puts "What game?"
    save_to_load = gets.chomp
    saved_game = YAML.load_file("saved_games/#{save_to_load}")
    @rand_word = saved_game.instance_variable_get(:@rand_word)
    @num_of_guesses = saved_game.instance_variable_get(:@num_of_guesses)
    @array = saved_game.instance_variable_get(:@array)
    @ar = saved_game.instance_variable_get(:@ar)
    @used_letters = saved_game.instance_variable_get(:@used_letters)
    puts "Letters used: #{@used_letters}"
    puts "#{@ar}"
    self.num_of_guesses
  end
end

a = Hangman.new
