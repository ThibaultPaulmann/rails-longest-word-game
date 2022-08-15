require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alpha = ('A'..'Z').to_a
    @grid = []
    # gets 10 random characters
    (1..10).each { |_| @grid << alpha.sample }
  end

  def score
    @result = {}
    @grid = params[:letters].split(' ')
    @word = params[:word]

    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    word_data = JSON.parse(URI.parse(url).open.read)

    if !in_grid?(@word.upcase, @grid)
      @result[:message] = 'Invalid - Not in grid'
    elsif !(word_data['found'])
      @result[:message] = 'Invalid - Not an english word'
    else
      @result[:message] = 'valid'
      @result[:score] = @word.length
    end
  end

  def in_grid?(attempt, grid)
    attempt.chars.all? do |char|
      grid.include?(char) && attempt.count(char) <= grid.count(char)
    end
  end
end
