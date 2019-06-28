class Scene
  class Game
    def initialize(*args)
      args = *args
      @digit = args[0]
      @answer = generate_answer(args[0], args[1])
      @sprite_background = Sprite.new
      @sprite_background.bitmap = Bitmap.new(640, 320)
      @sprite_background.bitmap.blt(0, 0, Bitmap.new("img/background.png"), Rect.new(0, 0, 320, 320))
    end

    def generate_answer(digit, range)
      return range if digit == 2
      answer = Array.new
      while answer.size < digit
        idx = rand(range.size)
        answer.push(range[idx])
        range.delete_at(idx)
      end
      return answer
    end

    def update
      Graphics.update
      InputManager.update
    end
  end
end