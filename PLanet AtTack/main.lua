-- Project: Attack of the Cuteness Game
-- http://MasteringCoronaSDK.com
-- Version: 1.0
-- Copyright 2013 J. A. Whye. All Rights Reserved.
-- "Space Cute" art by Daniel Cook (Lostgarden.com) 

-- housekeeping stuff

display.setStatusBar(display.HiddenStatusBar)

local centerX = display.contentCenterX
local centerY = display.contentCenterY
--audio objects
local soundKill=audio.loadSound("boing-1.wav")
local soundBlast=audio.loadSound("blast.mp3")
local soundLose=audio.loadSound("wahwahwah.mp3")

-- set up forward references
local speedBump = 0
local spawnEnemy
local shipSmash
local gameTitle
local score = 0
local hitPlanet
local scoreText
local planetDamage
local planet



local function splash()local splashscreen = display.newImage( "meadow.png", 0, 0, true );
splashscreen.x = display.contentCenterX
splashscreen.y = display.contentCenterY

local function removeSplash(event)  
splashscreen:removeSelf()   
splashscreen = nil
end
timer.performWithDelay(2000,removeSplash)
end

--create  playscreen
local function createPlayScreen()

local background=display.newImage("background.png")
background.y=130
background.alpha=0
--background:addEventListener("tap",shipSmash)

planet =display.newImage("planet.png")
planet.x=centerX
planet.y=display.contentHeight+60
planet.alpha=0
--planet:addEventListener("tap",shipSmash)

transition.to(background,{time=2000,y=centerY,alpha=1,x=centerX})

local function showTitle()
	 gameTitle=display.newImage("gametitle.png")
	gameTitle.alpha=0
	gameTitle:scale(4,4)
	transition.to(gameTitle,{time=500,xScale=1,yScale=1,alpha=1})
	--spawnEnemy()
	startGame()
end
	transition.to(planet,{time=2000,y=centerY,alpha=1,onComplete=showTitle})
end

function  spawnEnemy()
	--local  enemy=display.newImage("beetleship.png")
	--enemy.x = math.random(20,display.contentWidth-20)
	--enemy.y = math.random(20,display.contentHeight-20)
	local enemypics = {"beetleship.png","octopus.png", "rocketship.png"}
	local enemy = display.newImage(enemypics[math.random (#enemypics)])

	enemy:addEventListener("tap",shipSmash)

	if math.random(2)==1 then
		enemy.x=math.random(-100,-10)
		else 
		enemy.x=math.random(display.contentWidth+10,display.contentWidth+100)
	end
	enemy.y=math.random(display.contentHeight)
	enemy.trans=transition.to(enemy,{x=centerX,y=centerY,time=math.random(2500-speedBump, 4500-speedBump),onComplete=hitPlanet})	
end

function startGame()
	local text=display.newText("Tap here to Start!For Yuvi and Aasi",0,0,"Helvetica",24)
	text.x=centerX
	text.y=display.contentHeight-30
	text:setTextColor(0.16, 0.14, 1)
	local function goAway(event)
		display.remove(event.target)
		text=nil
		display.remove(gameTitle)
		spawnEnemy()
		scoreText =display.newText("Score : 0",0,0,"Helvetica",22)
		scoreText.x=centerX
		scoreText.y= 10
		score=0
		planet.numHits = 10
	end
	text:addEventListener("tap",goAway)
end


function hitPlanet(obj)
	display.remove(obj)
	planetDamage()
	audio.play(soundBlast)
	if planet.numHits > 1 then       -----so that no more enemies are spawned after planet has been destroyed
		spawnEnemy()
	end
end

function shipSmash(event)
	obj =event.target
	display.remove(obj)
	audio.play(soundKill)
	transition.cancel(event.target.trans)
	score=score + 30
	scoreText.text = "Score: " .. score
	spawnEnemy()
	return true
end

function planetDamage()
   planet.numHits = planet.numHits - 2
	planet.alpha = planet.numHits / 10
	if planet.numHits < 2 then
		planet.alpha = 0
		display.remove(scoreText)
		display.newImage("Untitled.png");
		--to restart the game after planet has been destroyed
		timer.performWithDelay ( 1000, startGame )
		audio.play ( soundLose )
		--
		else
   local function goAway(obj)
	planet.xScale=1
	planet.yScale=1
	planet.alpha=planet.numHits / 10
   end
transition.to(planet,{time=200,xScale=1.3,yScale=1.3,alpha=1,onComplete=goAway})
	end
end

splash()
createPlayScreen()
--startGame()