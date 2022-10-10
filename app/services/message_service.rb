class MessageService
  
  def self.init(type)
    case type
    when "level" then
      LevelMessageService.new
    when "exp" then
      ExpMessageService.new
    end
  end
end

class LevelMessageService

  attr_reader :type, :exp, :next_exp, :name
  def message(exp, charactor, category)
    @type = "level"
    @exp = exp
    @next_exp = charactor.send("#{category.column_name}_exp")
    @name = category.name
    self
  end
end

class ExpMessageService
  attr_reader :type, :exp, :next_exp, :name
  def message(exp, charactor, category)
    @type = "exp"
    @exp = exp
    @next_exp = charactor.send("#{category.column_name}_exp")
    @name = category.name
    self
  end
end
