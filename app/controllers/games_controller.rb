require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
  end

  def score
    @letters = params[:letters].downcase.split   # bc the form will give us an string and we want an array
    @word = params[:word].downcase

    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    response = URI.open(url).read
    parsed_res = JSON.parse(response)

    if parsed_res["found"] && valid2?
      @score = parsed_res["length"]
    elsif parsed_res["found"] && !valid2?
      @score = "0 bc the word was not in the grid map"
    else
      @score = "0 bc this is not a word man"
    end
  end

  private

  def valid?
    @word.chars.each do |char|
      if @letters.include?(char)
        index = @letters.index(char)
        @letters.delete_at(index)
      else
        return false
      end
    end
  end

  def valid2?
    @word.char.all? do |char|
      @word.count(char) <= @letters.count(char)
    end
  end
end
