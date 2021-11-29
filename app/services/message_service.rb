class MessageService
  
  def self.init(type)
    case type
    when "level" then
      LevelMessageService.new
    when "exp" then
      ExpMessageService.new
    when "skill" then
      SkillMessageService.new
    end
  end
end

class SkillMessageService

  attr_reader :type, :name, :level, :explanation

  def message(cs)
    @type = "skill"
    @name = cs.skill.name
    @level = cs.level
    @explanation = cs.skill.explanation
    self
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