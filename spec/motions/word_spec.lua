local Buffer = require("lib/buffer")
local Selection = require("lib/selection")
local Word = require("lib/motions/word")

describe("Word", function()
  it("has a name", function()
    assert.are.equals("word", Word:new().name)
  end)

  describe("#getRange", function()
    it("handles simple words", function()
      local selection = Selection:new(0, 0)
      local buffer = Buffer:new("cat dog mouse", selection)
      local word = Word:new()

      assert.are.same(
        {
          start = 0,
          finish = 4,
          mode = "exclusive",
          direction = "characterwise"
        },
        word:getRange(buffer)
      )
    end)

    it("deals with being on a new line", function()
      local selection = Selection:new(2, 0)
      local buffer = Buffer:new("ok\n\nfish", selection)
      local word = Word:new()

      assert.are.same(
        {
          start = 2,
          finish = 3,
          mode = "exclusive",
          direction = "characterwise"
        },
        word:getRange(buffer)
      )
    end)

    it("continues from punctuation to the next word", function()
      local selection = Selection:new(2, 0)
      local buffer = Buffer:new("ab- cd", selection)
      local word = Word:new()

      assert.are.same(
        {
          start = 2,
          finish = 4,
          mode = "exclusive",
          direction = "characterwise"
        },
        word:getRange(buffer)
      )
    end)

    it("stops on punctuation", function()
      local selection = Selection:new(0, 0)
      local buffer = Buffer:new("ab-cd-ef", selection)
      local word = Word:new()

      assert.are.same(
        {
          start = 0,
          finish = 2,
          mode = "exclusive",
          direction = "characterwise"
        },
        word:getRange(buffer)
      )
    end)

    it("moves from punctuation", function()
      local selection = Selection:new(2, 0)
      local buffer = Buffer:new("ab-cd-ef", selection)
      local word = Word:new()

      assert.are.same(
        {
          start = 2,
          finish = 3,
          mode = "exclusive",
          direction = "characterwise"
        },
        word:getRange(buffer)
      )
    end)

    it("stops on new lines", function()
      local selection = Selection:new(4, 0)
      local buffer = Buffer:new("cat dog\nfish", selection)
      local word = Word:new()

      assert.are.same(
        {
          start = 4,
          finish = 7,
          mode = "exclusive",
          direction = "characterwise"
        },
        word:getRange(buffer)
      )
    end)

    it("flips to an inclusive motion if last word in buffer #focus", function()
      local selection = Selection:new(0, 0)
      local buffer = Buffer:new("cat", selection)
      local word = Word:new()

      assert.are.same(
        {
          start = 0,
          finish = 3,
          mode = "inclusive",
          direction = "characterwise"
        },
        word:getRange(buffer)
      )
    end)
  end)

  describe("#getMovements", function()
    it("returns the key sequence to move by word", function()
      local word = Word:new()

      assert.are.same(
        {
          {
            modifiers = { 'alt' },
            key = 'right'
          }
        },
        word:getMovements()
      )
    end)
  end)
end)
