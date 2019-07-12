class UserData
  FILE_NAME = "save.data"
  LastData = Struct.new(:digit, :range, :my_answer, :real_answer, :log)

  attr_reader :last_used

  def initialize
    if FileTest.exist?(FILE_NAME)
      load
    else
      @last_used = LastData.new
      @last_used.digit = 1
      @last_used.range = 0
      @last_used.my_answer = []
      @last_used.real_answer = []
      @last_used.log = []
      save
    end
  end

  def save
    file = File.open(FILE_NAME, "wb")
    Marshal.dump(@last_used, file)
    file.close
  end

  def load
    file = File.open(FILE_NAME, "rb")
    @last_used = Marshal.load(file)
    file.close
  end
end