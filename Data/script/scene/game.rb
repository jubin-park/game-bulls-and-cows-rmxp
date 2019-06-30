class Scene
  class Game
    def initialize(*args)
      args = *args
      @digit = args[0]
      @answer = generate_answer(args[0], args[1].clone)
      @sprite_black = Sprite.new
      @sprite_black.bitmap = Bitmap.new(320, 320)
      @sprite_black.bitmap.fill_rect(0, 0, 320, 320, Color.new(0, 0, 0))
      @sprite_black.z = 50
      @sprite_background = Sprite.new
      @sprite_background.bitmap = Bitmap.new(640, 320)
      @sprite_background.bitmap.blt(0, 0, Bitmap.new("img/background.png"), Rect.new(0, 0, 320, 320))
      bmp = Bitmap.new("img/hole.png")
      sx = (320 - @digit * 34) / 2
      @button_hole = Array.new(@digit) do |i|
        Button.new(32, 32) do
          {
            :x => sx + i * 34,
            :y => 100,
            :bitmap => [bmp],
            :index => i
          }
        end
      end
      @button_hole.each do |button|
        button.set_method(:button_down, method(:m_button_hole_down))
        button.set_method(:button_up, method(:m_button_hole_up))
        button.z = 1
      end
      bmp_item = Bitmap.new(576, 16)
      bmp_item.blt(0, 0, Bitmap.new("img/numbers.png"), Rect.new(0, 0, 160, 16))
      bmp_item.blt(160, 0, Bitmap.new("img/alphabets.png"), Rect.new(0, 0, 416, 16))
      @sprite_item = Array.new(args[1].length) {Sprite.new}
      @sprite_item.each_index do |i|
        @sprite_item[i].bitmap = bmp_item
        @sprite_item[i].x = i * 16
        @sprite_item[i].src_rect.x = i * 16
        @sprite_item[i].src_rect.width = 16
        @sprite_item[i].z = 2
      end
      @phase = 0
    end

    def dispose

    end

    def m_button_hole_down(index)
      p index
    end

    def m_button_hole_up(index)

    end

    def update_phase
      case @phase
      when 0
        @sprite_black.opacity -= 10
        @sprite_black.opacity = 0 if @sprite_black.opacity < 0
        return if @sprite_black.opacity != 0
        @phase = -1
      end
    end

    def update
      Graphics.update
      InputManager.update
      update_phase
      @button_hole.each do |button|
        button.update
      end
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
  end
end