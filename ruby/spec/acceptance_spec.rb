require 'ugly_trivia/game'

RSpec.describe UglyTrivia::Game do
  context 'construction' do
    it 'should succeed' do
      expect{UglyTrivia::Game.new}.to_not raise_error
    end
  end

  context 'adding players' do
    let(:game) { UglyTrivia::Game.new }

    it 'should start with no players' do
      expect(game.how_many_players).to eq 0
    end

    it 'should add one player per call to #add' do
      allow($stdout).to receive(:puts)
      player_counts = 5.times.collect{ |ii|
        game.add("Player #{ii}")
        game.how_many_players
      }
      expect(player_counts).to eq [1,2,3,4,5]
    end

    it 'should become playable with two or more players' do
      allow($stdout).to receive(:puts)
      playables = 5.times.collect{ |ii|
        game.add("Player #{ii}")
        game.is_playable?
      }
      expect(playables).to eq [false, true, true, true, true]
    end
  end

  context 'game scenario' do
    let(:game) { UglyTrivia::Game.new }

    it 'should behave as expected' do
      expect{game.add('Chet')}.to output("Chet was added\nThey are player number 1\n").to_stdout
      expect{game.add('Pat')}.to output("Pat was added\nThey are player number 2\n").to_stdout
      expect{game.add('Sue')}.to output("Sue was added\nThey are player number 3\n").to_stdout

      ## category locations
      expect{game.roll(0)}.to output("Chet is the current player\n" + "They have rolled a 0\n" + "Chet's new location is 0\n"  + "The category is Pop\n"     + "Pop Question 0\n"     ).to_stdout
      expect{game.roll(1)}.to output("Chet is the current player\n" + "They have rolled a 1\n" + "Chet's new location is 1\n"  + "The category is Science\n" + "Science Question 0\n" ).to_stdout
      expect{game.roll(1)}.to output("Chet is the current player\n" + "They have rolled a 1\n" + "Chet's new location is 2\n"  + "The category is Sports\n"  + "Sports Question 0\n"  ).to_stdout
      expect{game.roll(1)}.to output("Chet is the current player\n" + "They have rolled a 1\n" + "Chet's new location is 3\n"  + "The category is Rock\n"    + "Rock Question 0\n"    ).to_stdout
      expect{game.roll(1)}.to output("Chet is the current player\n" + "They have rolled a 1\n" + "Chet's new location is 4\n"  + "The category is Pop\n"     + "Pop Question 1\n"     ).to_stdout
      expect{game.roll(1)}.to output("Chet is the current player\n" + "They have rolled a 1\n" + "Chet's new location is 5\n"  + "The category is Science\n" + "Science Question 1\n" ).to_stdout
      expect{game.roll(1)}.to output("Chet is the current player\n" + "They have rolled a 1\n" + "Chet's new location is 6\n"  + "The category is Sports\n"  + "Sports Question 1\n"  ).to_stdout
      expect{game.roll(1)}.to output("Chet is the current player\n" + "They have rolled a 1\n" + "Chet's new location is 7\n"  + "The category is Rock\n"    + "Rock Question 1\n"    ).to_stdout
      expect{game.roll(1)}.to output("Chet is the current player\n" + "They have rolled a 1\n" + "Chet's new location is 8\n"  + "The category is Pop\n"     + "Pop Question 2\n"     ).to_stdout
      expect{game.roll(1)}.to output("Chet is the current player\n" + "They have rolled a 1\n" + "Chet's new location is 9\n"  + "The category is Science\n" + "Science Question 2\n" ).to_stdout
      expect{game.roll(1)}.to output("Chet is the current player\n" + "They have rolled a 1\n" + "Chet's new location is 10\n" + "The category is Sports\n"  + "Sports Question 2\n"  ).to_stdout
      expect{game.roll(1)}.to output("Chet is the current player\n" + "They have rolled a 1\n" + "Chet's new location is 11\n" + "The category is Rock\n"    + "Rock Question 2\n"    ).to_stdout

      ## location wrap around
      expect{game.roll(1)}.to output("Chet is the current player\n"  + "They have rolled a 1\n"  + "Chet's new location is 0\n"  + "The category is Pop\n"  + "Pop Question 3\n" ).to_stdout
      expect{game.roll(15)}.to output("Chet is the current player\n" + "They have rolled a 15\n" + "Chet's new location is 3\n"  + "The category is Rock\n" + "Rock Question 3\n").to_stdout

      ## correct answer advances to next player
      expect{game.was_correctly_answered}.to output("Answer was correct!!!!\n" + "Chet now has 1 Gold Coins.\n").to_stdout
      expect{game.roll(1)}.to output("Pat is the current player\n" + "They have rolled a 1\n" + "Pat's new location is 1\n"  + "The category is Science\n" + "Science Question 3\n" ).to_stdout

      ## incorrect answer advances sends player to penalty box and advances to next player
      expect{game.was_incorrectly_answered}.to output("Question was incorrectly answered\n" + "Pat was sent to the penalty box\n").to_stdout
      expect{game.roll(1)}.to output("Sue is the current player\n" + "They have rolled a 1\n" + "Sue's new location is 1\n"  + "The category is Science\n" + "Science Question 4\n" ).to_stdout

      ## turn wrapping
      expect{game.was_correctly_answered}.to output("Answer was correct!!!!\n" + "Sue now has 1 Gold Coins.\n").to_stdout
      expect{game.roll(1)}.to output("Chet is the current player\n" + "They have rolled a 1\n" + "Chet's new location is 4\n"  + "The category is Pop\n" + "Pop Question 4\n" ).to_stdout

      expect{game.was_correctly_answered}.to output(/Chet now has 2 Gold Coins./).to_stdout

      ## cannot escape penalty box with even roll, even with correct answer
      expect{game.roll(2)}.to output("Pat is the current player\n" + "They have rolled a 2\n" + "Pat is not getting out of the penalty box\n" ).to_stdout

      expect{game.roll(1)}.to output("Sue is the current player\n" + "They have rolled a 1\n" + "Sue's new location is 2\n"  + "The category is Sports\n" + "Sports Question 3\n" ).to_stdout
      expect{game.was_correctly_answered}.to output(/Sue now has 2 Gold Coins./).to_stdout
      expect{game.roll(1)}.to output("Chet is the current player\n" + "They have rolled a 1\n" + "Chet's new location is 5\n"  + "The category is Science\n" + "Science Question 5\n" ).to_stdout
      expect{game.was_correctly_answered}.to output(/Chet now has 3 Gold Coins./).to_stdout

      ## cannot escape penalty box with even roll, with incorrect answer
      expect{game.roll(2)}.to output("Pat is the current player\n" + "They have rolled a 2\n" + "Pat is not getting out of the penalty box\n" ).to_stdout

      expect{game.roll(1)}.to output(/Sue is the current player/ ).to_stdout
      expect{game.was_correctly_answered}.to output(/Sue now has 3 Gold Coins./).to_stdout
      expect{game.roll(1)}.to output(/Chet is the current player/ ).to_stdout
      expect{game.was_correctly_answered}.to output(/Chet now has 4 Gold Coins./).to_stdout

      ## can escape penalty box with odd roll
      expect{game.roll(3)}.to output("Pat is the current player\n" + "They have rolled a 3\n" + "Pat is getting out of the penalty box\n" + "Pat's new location is 4\n" + "The category is Pop\n" + "Pop Question 5\n").to_stdout
      expect{game.was_correctly_answered}.to output(/Pat now has 1 Gold Coins./).to_stdout

      ## advance to victory condition - six gold coins
      expect{game.roll(1)}.to output(/Sue is the current player/ ).to_stdout
      expect{game.was_correctly_answered}.to output(/Sue now has 4 Gold Coins./).to_stdout
      expect{game.roll(1)}.to output(/Chet is the current player/ ).to_stdout
      expect{game.was_correctly_answered}.to output(/Chet now has 5 Gold Coins./).to_stdout
      expect{game.roll(1)}.to output(/Pat is the current player/ ).to_stdout
      expect{game.was_correctly_answered}.to output(/Pat now has 2 Gold Coins./).to_stdout
      expect{game.roll(1)}.to output(/Sue is the current player/ ).to_stdout
      expect{game.was_correctly_answered}.to output(/Sue now has 5 Gold Coins./).to_stdout
      expect{game.roll(1)}.to output(/Chet is the current player/ ).to_stdout

      allow($stdout).to receive(:puts)
      expect(game.was_correctly_answered).to be_falsey
    end
  end
end
