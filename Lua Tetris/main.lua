pieces = {
    { -- O
        {0,0,0,0},
        {0,1,1,0},
        {0,1,1,0},
        {0,0,0,0}
    },
    { -- I
        {0,0,0,0},
        {0,0,0,0},
        {1,1,1,1},
        {0,0,0,0}
    },
    { -- L
        {0,0,0,0},
        {0,0,1,0},
        {1,1,1,0},
        {0,0,0,0}
    },
    { -- J
        {0,0,0,0},
        {0,1,0,0},
        {0,1,1,1},
        {0,0,0,0}
    },
    { -- S
        {0,0,0,0},
        {0,0,1,1},
        {0,1,1,0},
        {0,0,0,0}
    },
    { -- Z
        {0,0,0,0},
        {1,1,0,0},
        {0,1,1,0},
        {0,0,0,0}
    },
    { -- T
        {0,0,0,0},
        {0,0,1,0},
        {0,1,1,1},
        {0,0,0,0}
    }
}

grid = {
    {2,0,0,0,0,0,0,0,0,0,0,2},
    {2,0,0,0,0,0,0,0,0,0,0,2},
    {2,0,0,0,0,0,0,0,0,0,0,2},
    {2,0,0,0,0,0,0,0,0,0,0,2},
    {2,0,0,0,0,0,0,0,0,0,0,2},
    {2,0,0,0,0,0,0,0,0,0,0,2},
    {2,0,0,0,0,0,0,0,0,0,0,2},
    {2,0,0,0,0,0,0,0,0,0,0,2},
    {2,0,0,0,0,0,0,0,0,0,0,2},
    {2,0,0,0,0,0,0,0,0,0,0,2},
    {2,0,0,0,0,0,0,0,0,0,0,2},
    {2,0,0,0,0,0,0,0,0,0,0,2},
    {2,0,0,0,0,0,0,0,0,0,0,2},
    {2,0,0,0,0,0,0,0,0,0,0,2},
    {2,0,0,0,0,0,0,0,0,0,0,2},
    {2,0,0,0,0,0,0,0,0,0,0,2},
    {2,0,0,0,0,0,0,0,0,0,0,2},
    {2,0,0,0,0,0,0,0,0,0,0,2},
    {2,0,0,0,0,0,0,0,0,0,0,2},
    {2,0,0,0,0,0,0,0,0,0,0,2},
    {2,0,0,0,0,0,0,0,0,0,0,2},
    {2,0,0,0,0,0,0,0,0,0,0,2},
    {2,0,0,0,0,0,0,0,0,0,0,2},
    {2,0,0,0,0,0,0,0,0,0,0,2},
    {2,2,2,2,2,2,2,2,2,2,2,2}
}


TILE_SIZE = 40
WIDTH = 12
HEIGHT = 25

active_piece = pieces[love.math.random(#pieces)]
active_piece_x = 3
active_piece_y = -1

function love.load()
    -- Start options
    love.window.setIcon(love.image.newImageData("icon.png"))
    love.window.setTitle( "Cosmic Tetris" )
    love.window.setMode((WIDTH)*TILE_SIZE,(HEIGHT-5)*TILE_SIZE)
    step = 0
    speed = 0.5
    key_down = false
    can_rotate = true
    soundRotate = love.audio.newSource("rotate.wav", "static")
    soundRowClear = love.audio.newSource("rowClear.wav", "static")
    soundGameOver = love.audio.newSource("gameOver.wav", "static")
    musicTetris = love.audio.newSource("Tetris.mp3", "static")
    musicTetris:setVolume(0.4)
    musicTetris:play()
    -- print_grid(grid)
end

function love.update(dt)
    step = step + dt
    if key_down then
        speed = 0.2
    end
    update_grid(active_piece,1)
    if step > speed then
        tick_move()
        game_over_check()
        -- print_grid(grid)
        can_rotate = true
        step = 0
    end
end

function love.draw()
    love.graphics.setColor(1,1,1)

    for i=1,HEIGHT-5 do    
        for j=2,WIDTH-1 do
            love.graphics.rectangle('line',(j-1)*TILE_SIZE,(i-1)*TILE_SIZE,TILE_SIZE,TILE_SIZE)
        end
    end

    draw_piece(active_piece,active_piece_x,active_piece_y)
    draw_other_pieces()
end

function love.keypressed(key, unicode)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'up' and can_rotate then	
        can_rotate = false		
        active_piece = rotate(active_piece)
    elseif key == 'left' then
        if can_move(-1)	then 
            active_piece_x = active_piece_x - 1
        end		
    elseif key == 'right' then			
        if can_move(1) then 
            active_piece_x = active_piece_x + 1
        end	
    elseif key == 'down' then			
        key_down = true
    elseif key == 's' then			
        save_game()
    elseif key == 'l' then			
        load_game()
    end
    
end

function love.keyreleased(key, unicode)
    if key == 'down' then		
        speed = 0.5	
        key_down = false
    end
end

function rotate(pieceIn)
    pieceOut = {
        {},{},{},{}
    }

    for j = 1, 4 do
        for i = 1, 4 do
            pieceOut[j][5-i] = pieceIn[i][j]
        end
    end

    for i = 1, 4 do
        for j = 1, 4 do
            if pieceOut[i][j] == 1 then
                if active_piece_x + j >= WIDTH or active_piece_x + j <= 1 then
                    return pieceIn
                end
                if active_piece_y + i >= HEIGHT-3 then
                    return pieceIn
                end
                if grid[active_piece_y + i + 1][active_piece_x + j] == 2 then
                    return pieceIn
                end
            end
        end
    end
    soundRotate:play()
    return pieceOut
end

function draw_piece(piece, pos_x, pos_y)
    y = 1
    while y <= 4 do
        x = 1
        while x <= 4 do
            if piece[y][x] == 1 then
                draw_pos_x = (pos_x + x) * TILE_SIZE
                draw_pos_y = (pos_y + y) * TILE_SIZE
                draw_tile(draw_pos_x, draw_pos_y, {1,0,0})
            end
            x = x + 1
        end
        y = y + 1
    end
end

function draw_tile(x, y, color)
    love.graphics.setColor(color)
    love.graphics.rectangle("fill", x - TILE_SIZE, y - TILE_SIZE, TILE_SIZE, TILE_SIZE)
end

function tick_move()
    check_for_collision(grid,active_piece)
    active_piece_y = active_piece_y + 1
end

function update_grid(piece, val)
    clear_grid()
    y = 1
    while y < 5 do
        x = 1
        while x < 5 do
            if piece[y][x] == 1 then
                grid[active_piece_y + (y+4)][active_piece_x + (x)] = val
            end
            x = x + 1
        end
        y = y + 1
    end
end

-- function print_grid(grid) -- debug only
--     for i = 1, 255 do
--         print()
--     end
    
--     y = 1
--     while y < HEIGHT + 1 do
--         io.write(grid[y][1]," ",grid[y][2]," ",grid[y][3]," ",grid[y][4]," ",grid[y][5]," ",grid[y][6]," ",grid[y][7]," ",grid[y][8]," ",grid[y][9]," ",grid[y][10]," ",grid[y][11]," ",grid[y][12],"\n")
--         y = y + 1
--     end
    
-- end

function clear_grid()
    for i=1,HEIGHT-1 do    
        for j=2,WIDTH-1 do
            if grid[i][j] == 1 then
                grid[i][j]=0
            end
        end
    end
end

function check_for_collision(grid, piece)
    i = 1
    while i < HEIGHT + 1 do
        j = 2
        while j < WIDTH do
            if grid[i][j] == 1 and grid[i+1][j] == 2 then
                update_grid(piece,2)
                clear_full_width()
                new_active_piece()
                return
            end
            j = j + 1
        end
        i = i + 1
    end 
end

function new_active_piece()
    active_piece = pieces[love.math.random(#pieces)]
    active_piece_x = 3
    active_piece_y = -1
end

function draw_other_pieces()
    i = 1
    while i < HEIGHT do
        j = 2
        while j < WIDTH do
            if grid[i][j] == 2 then
                draw_tile((j)*TILE_SIZE,(i-4)*TILE_SIZE,{0,1,0})
            end
            j = j + 1
        end
        i = i + 1
    end
end

function can_move(direction)
    i = 1
    while i < HEIGHT + 1 do
        j = 2
        while j < WIDTH do
            if grid[i][j] == 1 and grid[i][j + direction] == 2 then
                return false
            end
            j = j + 1
        end
        i = i + 1
    end
    return true
end

function clear_full_width()
    i = HEIGHT - 1
    while i >= 1 do
        j = 2
        while j < WIDTH do
            if grid[i][j] ~= 2 then
                break
            end
            if grid[i][j] == 2 and j == WIDTH - 1 then
                clear_loop(i)
                soundRowClear:play()
                i = HEIGHT - 1
                j = 2
            end
            j = j + 1
        end
        i = i - 1
    end
end

function clear_loop(row)
    i = row
    while i > 0 do
        j = 2
        while j < WIDTH do
            if i == 1 then
                grid[i][j] = 0
            else
                grid[i][j] = grid[i-1][j]
            end
            j = j + 1
        end
        i = i - 1
    end
end

function save_game()
    save_string = tostring(active_piece_x).."\n"..tostring(active_piece_y).."\n"

    for i=1,HEIGHT do
        save_string = save_string..table.concat(grid[i]).."\n"
    end

    for i=1,4 do
        save_string = save_string..table.concat(active_piece[i]).."\n"
    end


    love.filesystem.write('saved_progress.txt', save_string)
end

function load_game()
    
    load_table = {}
    for line in love.filesystem.lines('saved_progress.txt') do
        load_table[#load_table + 1] = line
    end


    active_piece_x = tonumber(load_table[1])
    active_piece_y = tonumber(load_table[2])

    i = 1
    while i < HEIGHT do
        j = 1
        while j <= WIDTH do
            grid[i][j] = tonumber(load_table[3 + (i-1)]:sub(j,j))
            j = j + 1
        end
        i = i + 1
    end


    i = 1
    while i <= 4 do
        j = 1
        while j <= 4 do
            active_piece[i][j] = tonumber(load_table[28+(i-1)]:sub(j,j))
            j = j + 1
        end
        i = i + 1
    end

end

function game_over_check()
    for i=2,WIDTH-1 do
        if grid[6][i] == 2 then
            soundGameOver:play()
            love.timer.sleep(1)
            love.event.quit()
        end
    end
    
end