module UglyTrivia
  class Game
    def initialize
      @players        = []
      @places         = Array.new(6, 0)
      @purses         = Array.new(6, 0)
      @in_penalty_box = Array.new(6, nil)

      @pop_questions     = []
      @science_questions = []
      @sports_questions  = []
      @rock_questions    = []

      @current_player = 0

      50.times do |ii|
        @pop_questions.push     "Pop Question #{ii}"
        @science_questions.push "Science Question #{ii}"
        @sports_questions.push  "Sports Question #{ii}"
        @rock_questions.push    "Rock Question #{ii}"
      end
    end

    def how_many_players
      @players.length
    end

    def is_playable?
      how_many_players >= 2
    end

    def add(player_name)
      @players.push player_name
      @places[how_many_players] = 0
      @purses[how_many_players] = 0
      @in_penalty_box[how_many_players] = false

      puts "#{player_name} was added"
      puts "They are player number #{@players.length}"

      true
    end

    def was_correctly_answered
      _handle_correct_answer
      should_continue_game = _game_should_continue
      _move_to_next_player
      return should_continue_game
    end

    def wrong_answer
      puts 'Question was incorrectly answered'
      puts "#{@players[@current_player]} was sent to the penalty box"
      @in_penalty_box[@current_player] = true

      _move_to_next_player
      should_continue_game = true
      return should_continue_game
    end

    def roll(roll)
      puts "#{@players[@current_player]} is the current player"
      puts "They have rolled a #{roll}"

      _handle_penalty_box(roll: roll)

      if @in_penalty_box[@current_player]
        _move_to_next_player
      else
        _advance_current_player_location(spaces: roll)
        _ask_question
      end
    end

    private

    def _handle_penalty_box(roll:)
      if @in_penalty_box[@current_player]
        if roll % 2 != 0
          puts "#{@players[@current_player]} is getting out of the penalty box"
          @in_penalty_box[@current_player] = false
        else
          puts "#{@players[@current_player]} is not getting out of the penalty box"
        end
      end
    end

    def _advance_current_player_location(spaces:)
      @places[@current_player] = @places[@current_player] + spaces
      @places[@current_player] = @places[@current_player] - 12 if @places[@current_player] > 11

      puts "#{@players[@current_player]}'s new location is #{@places[@current_player]}"
      puts "The category is #{_current_category}"
    end

    def _move_to_next_player
      @current_player += 1
      @current_player = 0 if @current_player == @players.length
    end

    def _handle_correct_answer
      puts 'Answer was correct!!!!'
      @purses[@current_player] += 1
      puts "#{@players[@current_player]} now has #{@purses[@current_player]} Gold Coins."
    end

    def _ask_question
      puts @pop_questions.shift     if _current_category == 'Pop'
      puts @science_questions.shift if _current_category == 'Science'
      puts @sports_questions.shift  if _current_category == 'Sports'
      puts @rock_questions.shift    if _current_category == 'Rock'
    end

    def _current_category
      return 'Pop'     if @places[@current_player] == 0
      return 'Pop'     if @places[@current_player] == 4
      return 'Pop'     if @places[@current_player] == 8
      return 'Science' if @places[@current_player] == 1
      return 'Science' if @places[@current_player] == 5
      return 'Science' if @places[@current_player] == 9
      return 'Sports'  if @places[@current_player] == 2
      return 'Sports'  if @places[@current_player] == 6
      return 'Sports'  if @places[@current_player] == 10
      return 'Rock'
    end

  public

  private

    def _game_should_continue
      @purses[@current_player] < 6
    end
  end
end
