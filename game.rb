require 'pry'
require './player.rb'
require 'set'
class Game
    attr_reader :players, :fragment

    def initialize(*players)
        words = File.readlines("dictionary.txt").map(&:chomp)
        @players= [*players]
        @dictionary= Set.new(words)
        @turn_number = 0
        @fragment
        @ghost = "GHOST"
    end

    def game
        until @players.any? {|player| player.losses == 5}
            @fragment = ""
            play_round
            standings
        end
    end

    def play_round
        until round_over?(@fragment)
            turn
        end
        puts "The final word was #{@fragment}, #{previous_player.name} you lost"
        previous_player.losses += 1
    end

    def valid_play?(guess)
        downcase_guess = guess.downcase
        ("a".."z").to_a.include?(downcase_guess)
        total_fragment = "#{@fragment}#{downcase_guess}"
        @dictionary.any? {|ele| ele.start_with?(total_fragment)}
    end

    def round_over?(fragment)
        @dictionary.include?(fragment)
    end

    def current_player
        how_many_players = @players.length
        current_player = @players[@turn_number % how_many_players]
    end

    def previous_player
        @players[(players.index(current_player))-1]
    end

    def next_player
        @players[(players.index(current_player)+1) % @players.length]
    end

    def turn
        current_player.your_turn(@fragment)
        current_guess = current_player.guess
        if valid_play?(current_guess)
            @fragment = "#{@fragment}#{current_guess.downcase}"
            @turn_number+=1
        else
            current_player.alert_invalid_guess(current_guess)
            turn
        end
    end

    def standings
        @players.each do |player|
            if player.losses == 0
                puts "#{player.name} has no losses"
            else
                puts "#{player.name} is at #{@ghost[0...player.losses]}"
            end
        end
    end
end



if $PROGRAM_NAME == __FILE__
    game = Game.new(
        Player.new("Player 1"),
        Player.new("Player 2"),
        Player.new("Player 3"),
        Player.new("Player 4")
    )
end