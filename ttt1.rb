# Each methods prints one row
module Display
    def headings
        puts "   \s\s1\s\s \s\s2\s\s \s\s3\s\s"
    end

    def verticals
        puts "   \s\s\s\s\s|\s\s\s\s\s|\s\s\s\s\s"
    end

    def horizontals
        puts "   _____|_____|_____"
    end

    def variables

        @l = %w{A B C}   # letters
        @let = @count / 3 # letters progress every 3 iterations
        @n = %w{1 2 3} # numbers
        @num = @count % 3     # numbers return to 0 every 3 iterations

        print "\s#{@l[@count / 3]}\s"
        3.times do
            print "\s\s#{@cells[@l[@count / 3] + @n[@count % 3]]}\s\s"  # finding hash @cells values for one row
            print "|" unless @count % 3 == 2
            @count += 1
        end
        puts ""
    end

    def display
        @count = 0       # 0 - 9 for each cell

        30.times{ print "-" }
        puts ""

        headings
        3.times do
            verticals
            variables
            @count / 3 < 3 ? horizontals : verticals
        end
    end
end

class Game
    include Display

    def initialize
        @plays = 0
        @token = {1 => "X", 2 => "O"}
        @cells = Hash.new(" ")
        @win = false
    end

    def player
        @player = (@plays % 2) + 1
        puts ""
        puts "PLAYER #{@player}:"
        input
    end

    def input
        puts ""
        puts "Enter a number to place token"
        print "> "
        @pos_arr = gets.chomp.upcase.split(/[^A-C1-3]/)
        @pos = @pos_arr.join("")
        puts ""
        place
    end

    def place
        letter = (@pos[0] || "0").match(/[A-C]/)
        number = (@pos[1] || "0").match(/[1-3]/)

        if @cells.has_key? @pos
            error("  That space is already occupied,")
        elsif !letter || !number
            error("  Input not recognized,")
        else
            @cells[@pos] = @token[(@plays % 2) + 1]  # places player's token in appropriate cell
            @plays += 1
            display
            check_finish
        end
    end

    def check_finish
        @wins = [%w{A1 A2 A3}, %w{B1 B2 B3}, %w{C1 C2 C3}, %w{A1 B1 C1}, %w{A2 B2 C2}, %w{A3 B3 C3}, %w{A1 B2 C3}, %w{A3 B2 C1}]
        check = []
        @cells.each {|pos, tok| check << pos if tok == @token[@player]}
        winner = @wins.any? { |combo| (combo & check).size == 3 }

        if winner
            game_over("  PLAYER #{@player} WINS !!")
        elsif @cells.size == 9
            game_over("  GAME IS A DRAW")
        else
            player
        end
    end

    def game_over(result)
        puts ""
        puts "******************"
        puts result
        puts "******************"
        puts ""
    end

    def error(type)
        puts "!!!"
        puts type
        puts "  please try again."
        input
    end
end

g = Game.new
g.display
g.player
