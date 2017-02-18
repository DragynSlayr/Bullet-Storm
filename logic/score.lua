local Score = {}
local File_Handler = require("logic.fileHandler")
local FileHandler = File_Handler.init()

function Score.init()
  Score.highscore_file = "highscore.txt"
  Score.score = 0
  Score.smooth_score = 0
end

function Score.load()
  Score.highscore = tonumber(FileHandler.read(Score.highscore_file)) or 0 
end

function Score.update(current, dt)
  Score.smooth_score = Score.smooth_score + ((current - Score.smooth_score) * dt)
  Score.score = math.floor(Score.smooth_score)
  
  if current > Score.highscore then
    Score.highscore = current
  end
end

function Score.save()
  FileHandler.write(Score.highscore_file, Score.highscore)
end

Score.init()
Score.load()

return Score