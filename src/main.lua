CLIENT = false
SERVER = false

game 	= require 'game'
engine 	= require 'engine'

-- You should never have to touch anything in here.
-- Edit the init.lua in both the games and engine folder instead.

function love.load(arg)

	local args = {}
	for i, v in ipairs(arg) do
		args[v] = true
	end

	if args["-dedicated"] then
		SERVER = true
	else
		CLIENT = true
	end

	if args["-debug"] then
		_G.debugmode = true
	end

	engine.load()
	game.load()

	if not engine.config.exists("game") and not SERVER then
		engine.config.save("game", engine.config.defaultCFG())
	end

	if engine.network then

		if CLIENT then
			engine.network.client.start()
		end

		if SERVER then

			if not engine.config.exists("server") then
				engine.config.save("server", engine.config.defaultServerCFG())
			end

			love.window.setMode(1280, 720)
			if args["-gui"] then
				engine.network.server.start(true)
			else
				engine.network.server.start(false)
			end
		end

	end

end

function love.draw()

	game.draw()
	engine.draw()

end

function love.update(dt)

	engine.update(dt)

	if engine.console.getActive() == false then

		game.update(dt)

	end

end

function love.resize(w, h)

	engine.resize(w, h)
	game.resize(w, h)

end

function love.mousepressed(x, y, button)

	engine.mousepressed(x, y, button)

	if engine.console.getActive() == false then

		game.mousepressed(x, y, button)

	end

end
 
function love.mousereleased(x, y, button)

	engine.mousereleased(x, y, button)

	if engine.console.getActive() == false then

		game.mousereleased(x, y, button)

	end

end
 
function love.keypressed(key, unicode)

	engine.keypressed(key, unicode)

	if engine.console.getActive() == false then

		game.keypressed(key, unicode)

	end

end
 
function love.keyreleased(key)

	engine.keyreleased(key)

	if engine.console.getActive() == false then

		game.keyreleased(key)

	end

end

function love.textinput(text)

	engine.textinput(text)

	if engine.console.getActive() == false then

		game.textinput(text)

	end

end

function love.quit()

	if CLIENT then
		engine.network.client.disconnect()
	end

	if SERVER then
		engine.network.server.send("shutdown")
	end

	print("Shutting down ...")

end