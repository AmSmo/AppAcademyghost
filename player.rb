class Player

    attr_reader :name
    attr_accessor :losses
    def initialize(name)

        # puts "What's your name"
        @name = name # gets.chomp
        @losses= 0
    end

    def guess
        puts "#{@name}, Please enter a letter:"
        guess = gets.chomp.downcase
    end

    def alert_invalid_guess(guess)
        puts "#{guess} isn't a valid option"
        if guess.length > 1
            puts "You have guessed more than one letter"
        elsif !guess.is_a? String
            puts "You haven't guessed a letter"
        end
    end

    def your_turn(fragment)
        puts "We are at '#{fragment}'"
    end
end