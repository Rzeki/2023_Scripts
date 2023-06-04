require 'ruby2d'
require 'matrix'

set title: "Mario", width: 1200, height: 800

@background = Image.new(
    'level1.png',
    x: 0,
    width: 2604,
    height: Window.height 
)


@mario = Sprite.new(
    'mario_sprite.png',
    x: 20,
    y: 580,
    width: 100,
    height: 100,
    clip_width: 17,
    time: 200,
    animations: {
        walk: [
            {
                x: 15, y: 0,
                width: 17, height: 17,
                time: 100
            },
            {
                x: 33, y: 0,
                width: 17, height: 17,
                time: 200
            },
            {
                x: 50, y: 0,
                width: 17, height: 17,
                time: 300
            }
        ],
        idle: [
            {
                x: 0, y: 0,
                width: 17, height: 17,
                time: 100
            }
        ],
        jump: [
            {
                x: 83, y: 0,
                width: 17, height: 17,
                time: 100
            }
        ],
        die: [
            {
                x: 102, y: 0,
                width: 17, height: 17,
                time: 100
            }
        ]
    }
)

@level_hitboxes = [
    Rectangle.new(x: 562, y: 483, width: 200, height: 63, color: [1, 0, 0, 0]),
    Rectangle.new(x: 1841, y: 483, width: 200, height: 63, color: [1, 0, 0, 0]),
    Rectangle.new(x: 2185, y: 483, width: 67, height: 63, color: [1, 0, 0, 0]),
    Rectangle.new(x: 1059, y: 546, width: 140, height: 133, color: [1, 0, 0, 0]),
    Rectangle.new(x: 1623, y: 546, width: 140, height: 133, color: [1, 0, 0, 0]),
    Rectangle.new(x: 2400, y: 546, width: 140, height: 133, color: [1, 0, 0, 0]),
    Rectangle.new(x: 0, y: 680, width: 490, height: 130, color: [1, 0, 0, 0]),
    Rectangle.new(x: 635, y: 680, width: 565, height: 130, color: [1, 0, 0, 0]),
    Rectangle.new(x: 1345, y: 680, width: 1258, height: 130, color: [1, 0, 0, 0]),
    Rectangle.new(x: -50, y: 0, width: 50, height: Window.height, color: [1, 0, 0, 0]),
    Rectangle.new(x: @background.width, y: 0, width: 50, height: Window.height, color: [1, 0, 0, 0])
]

@level_coins = [
    [Sprite.new('coin_mario.png', x: 580, y: 420, clip_width: 133, width: 32, height: 56, time: 100, loop: true), Rectangle.new(x: 580, y: 420, width: 32, height: 56, color: [0, 1, 0, 0])],
    [Sprite.new('coin_mario.png', x: 646, y: 420, clip_width: 133, width: 32, height: 56, time: 100, loop: true), Rectangle.new(x: 646, y: 420, width: 32, height: 56, color: [0, 1, 0, 0])],
    [Sprite.new('coin_mario.png', x: 712, y: 420, clip_width: 133, width: 32, height: 56, time: 100, loop: true), Rectangle.new(x: 712, y: 420, width: 32, height: 56, color: [0, 1, 0, 0])],
    [Sprite.new('coin_mario.png', x: 1859, y: 420, clip_width: 133, width: 32, height: 56, time: 100, loop: true), Rectangle.new(x: 1859, y: 420, width: 32, height: 56, color: [0, 1, 0, 0])],
    [Sprite.new('coin_mario.png', x: 1925, y: 420, clip_width: 133, width: 32, height: 56, time: 100, loop: true), Rectangle.new(x: 1925, y: 420, width: 32, height: 56, color: [0, 1, 0, 0])],
    [Sprite.new('coin_mario.png', x: 1991, y: 420, clip_width: 133, width: 32, height: 56, time: 100, loop: true), Rectangle.new(x: 1991, y: 420, width: 32, height: 56, color: [0, 1, 0, 0])],
    [Sprite.new('coin_mario.png', x: 2203, y: 420, clip_width: 133, width: 32, height: 56, time: 100, loop: true), Rectangle.new(x: 2203, y: 420, width: 32, height: 56, color: [0, 1, 0, 0])]
]


@level_enemies = [
    [Sprite.new('goomba.png', x: 1810, y: 630, clip_width: 32, width: 50, height: 50, time: 100, loop: true), Rectangle.new(x: 1810, y: 630, width: 50, height: 50, color: [0, 0, 1, 0]),0.1]
]


for coin in @level_coins
    coin[0].play
end

for enemy in @level_enemies
    enemy[0].play
end

@mario_hitbox = Rectangle.new(x: @mario.x + 20, y: @mario.y + 5, width: 60, height:95, color: [1, 0, 0, 0])
@mario_velocity = Vector.zero(2)
@mario_can_jump = true
@mario_hp = 3
@score = 0

@score_text = Text.new(
    "Score: " + @score.to_s,
    x: Window.width - 500, y: 40,
    font: 'SuperMario256.ttf',
    style: 'bold',
    size: 50,
    color: 'black',
    z: 10
)

Image.new(
    'mario_head.png',
    x: Window.width - 150,
    y: 30,
    width: 50,
    height: 50 
)
@mario_hp_indicator = Text.new(
    "x" + @mario_hp.to_s,
    x: Window.width - 95, y: 40,
    font: 'SuperMario256.ttf',
    style: 'bold',
    size: 50,
    color: 'black',
    z: 10
)



on :key_held do |event|
    case event.key
    when 'left'
        if @level_hitboxes.any? { |hitbox| hitbox.contains?(@mario_hitbox.x, @mario_hitbox.y) || hitbox.contains?(@mario_hitbox.x, @mario_hitbox.y + @mario_hitbox.height) }
            @mario.x += 8
            @mario_hitbox.x += 8
        else
            @mario.play animation: :walk, flip: :horizontal
            if @mario_velocity[0] > -6
                @mario_velocity[0] -= 0.1
            end
        end
    when 'right'
        if @level_hitboxes.any? { |hitbox| hitbox.contains?(@mario_hitbox.x + @mario_hitbox.width, @mario_hitbox.y) || hitbox.contains?(@mario_hitbox.x + @mario_hitbox.width, @mario_hitbox.y + @mario_hitbox.height) }
            @mario.x -= 8
            @mario_hitbox.x -= 8
        elsif @mario.x + @mario_hitbox.width >= Window.width/2 && @background.x.abs < @background.width - Window.width
            @mario.play animation: :walk
            @mario_velocity[0] = 0
            @background.x -= 6
            for rect in @level_hitboxes
                rect.x -= 6
            end
            for coin in @level_coins
                coin[0].x -= 6
                coin[1].x -= 6
            end
            for enemy in @level_enemies
                enemy[0].x -= 6
                enemy[1].x -= 6
            end
        else
            @mario.play animation: :walk
            if @mario_velocity[0] < 6
                @mario_velocity[0] += 0.1
            end
        end
    end
end
    
def get_colliding_rect()
    for rect in @level_hitboxes
        if rect.contains?(@mario_hitbox.x, @mario_hitbox.y - 5) || rect.contains?(@mario_hitbox.x + @mario_hitbox.width, @mario_hitbox.y - 5)
            return rect
        end
        if rect.contains?(@mario_hitbox.x, @mario_hitbox.y + @mario_hitbox.height + 5) || rect.contains?(@mario_hitbox.x + @mario_hitbox.width, @mario_hitbox.y + @mario_hitbox.height + 5)
            return rect
        end
    end
    return nil
end

def get_coin()
    for coin in @level_coins
        if coin[1].contains?(@mario_hitbox.x, @mario_hitbox.y + @mario_hitbox.height/2) || coin[1].contains?(@mario_hitbox.x + @mario_hitbox.width/2, @mario_hitbox.y + @mario_hitbox.height/2 || coin[1].contains?(@mario_hitbox.x + @mario_hitbox.width, @mario_hitbox.y + @mario_hitbox.height/2))
            return coin
        end
    end
    return nil
end

# on :mouse_down do |event| #debug
#     puts [event.x.to_i - @background.x, event.y.to_i]
# end

on :key_up do |event|
    @mario.play animation: :idle, loop: true
    if event.key != "space" 
        @mario_velocity[0] = 0
    end
end

on :key_down do |event|
    case event.key
    when 'space'
        if @mario_can_jump
            @mario_can_jump = false
            @mario.y -= 15
            @mario_hitbox.y -= 15
            @mario_velocity[1] -= 12
        end
    end
end

def move_and_collide()
    if @level_hitboxes.any? { |hitbox| hitbox.contains?(@mario_hitbox.x, @mario_hitbox.y + @mario_hitbox.height + 5) || hitbox.contains?(@mario_hitbox.x + @mario_hitbox.width, @mario_hitbox.y + @mario_hitbox.height + 5) }
        r = get_colliding_rect()
        @mario.y = r.y - @mario.height
        @mario_hitbox.y = r.y - @mario.height
        @mario_velocity[1] = 0
        @mario_can_jump = true
    elsif @level_hitboxes.any? { |hitbox| hitbox.contains?(@mario_hitbox.x, @mario_hitbox.y - 5) || hitbox.contains?(@mario_hitbox.x + @mario_hitbox.width, @mario_hitbox.y - 5) }
        r = get_colliding_rect()
        @mario.y = r.y + r.height + 6
        @mario_hitbox.y = r.y + r.height + 6
        @mario_velocity[1] = 0
    else
        @mario.y += @mario_velocity[1]
        @mario_hitbox.y += @mario_velocity[1]
        @mario_velocity += Vector[0, 0.3]
    end
    @mario.x += @mario_velocity[0]
    @mario_hitbox.x += @mario_velocity[0]
    
end

def reset_level()
    @mario_velocity = Vector.zero(2)
    @mario.x = 20
    @mario.y = 580
    @mario_hitbox.x = @mario.x + 20 
    @mario_hitbox.y = @mario.y + 5
    for rect in @level_hitboxes
        rect.x -= @background.x
    end
    @mario_hp_indicator.remove
    @mario_hp_indicator = Text.new(
        "x" + @mario_hp.to_s,
        x: Window.width - 95, y: 40,
        font: 'SuperMario256.ttf',
        style: 'bold',
        size: 50,
        color: 'black',
        z: 10
    )
    @background.x = 0
    @score = 0
    @score_text.remove
        @score_text = Text.new(
            "Score: " + @score.to_s,
            x: Window.width - 500, y: 40,
            font: 'SuperMario256.ttf',
            style: 'bold',
            size: 50,
            color: 'black',
            z: 10
    )

    for coin in @level_coins
        coin[0].remove
        coin[1].remove
    end
    
    for enemy in @level_enemies
        enemy[0].remove
        enemy[1].remove
    end
    @level_hitboxes = [
        Rectangle.new(x: 562, y: 483, width: 200, height: 63, color: [1, 0, 0, 0]),
        Rectangle.new(x: 1841, y: 483, width: 200, height: 63, color: [1, 0, 0, 0]),
        Rectangle.new(x: 2185, y: 483, width: 67, height: 63, color: [1, 0, 0, 0]),
        Rectangle.new(x: 1059, y: 546, width: 140, height: 133, color: [1, 0, 0, 0]),
        Rectangle.new(x: 1623, y: 546, width: 140, height: 133, color: [1, 0, 0, 0]),
        Rectangle.new(x: 2400, y: 546, width: 140, height: 133, color: [1, 0, 0, 0]),
        Rectangle.new(x: 0, y: 680, width: 490, height: 130, color: [1, 0, 0, 0]),
        Rectangle.new(x: 635, y: 680, width: 565, height: 130, color: [1, 0, 0, 0]),
        Rectangle.new(x: 1345, y: 680, width: 1258, height: 130, color: [1, 0, 0, 0]),
        Rectangle.new(x: -50, y: 0, width: 50, height: Window.height, color: [1, 0, 0, 0]),
        Rectangle.new(x: @background.width, y: 0, width: 50, height: Window.height, color: [1, 0, 0, 0])
    ]
    
    @level_coins = [
        [Sprite.new('coin_mario.png', x: 580, y: 420, clip_width: 133, width: 32, height: 56, time: 100, loop: true), Rectangle.new(x: 580, y: 420, width: 32, height: 56, color: [0, 1, 0, 0])],
        [Sprite.new('coin_mario.png', x: 646, y: 420, clip_width: 133, width: 32, height: 56, time: 100, loop: true), Rectangle.new(x: 646, y: 420, width: 32, height: 56, color: [0, 1, 0, 0])],
        [Sprite.new('coin_mario.png', x: 712, y: 420, clip_width: 133, width: 32, height: 56, time: 100, loop: true), Rectangle.new(x: 712, y: 420, width: 32, height: 56, color: [0, 1, 0, 0])],
        [Sprite.new('coin_mario.png', x: 1859, y: 420, clip_width: 133, width: 32, height: 56, time: 100, loop: true), Rectangle.new(x: 1859, y: 420, width: 32, height: 56, color: [0, 1, 0, 0])],
        [Sprite.new('coin_mario.png', x: 1925, y: 420, clip_width: 133, width: 32, height: 56, time: 100, loop: true), Rectangle.new(x: 1925, y: 420, width: 32, height: 56, color: [0, 1, 0, 0])],
        [Sprite.new('coin_mario.png', x: 1991, y: 420, clip_width: 133, width: 32, height: 56, time: 100, loop: true), Rectangle.new(x: 1991, y: 420, width: 32, height: 56, color: [0, 1, 0, 0])],
        [Sprite.new('coin_mario.png', x: 2203, y: 420, clip_width: 133, width: 32, height: 56, time: 100, loop: true), Rectangle.new(x: 2203, y: 420, width: 32, height: 56, color: [0, 1, 0, 0])]
    ]
    
    
    @level_enemies = [
        [Sprite.new('goomba.png', x: 1810, y: 630, clip_width: 32, width: 50, height: 50, time: 100, loop: true), Rectangle.new(x: 1810, y: 630, width: 50, height: 50, color: [0, 0, 1, 0]),0.1]
    ]

    for coin in @level_coins
        coin[0].play
    end
    
    for enemy in @level_enemies
        enemy[0].play
    end
end

update do
    if !@mario_can_jump
        if @mario_velocity[0] >= 0
            @mario.play animation: :jump
        else
            @mario.play animation: :jump, flip: :horizontal
        end
    end

    if @mario.y > Window.height
        @mario_hp -= 1
        if @mario_hp == 0
            exit
        end
        reset_level()
    end

    c = get_coin()
    if c
        @score += 1
        c[0].remove
        c[1].remove
        @level_coins.delete(c)
        @score_text.remove
        @score_text = Text.new(
            "Score: " + @score.to_s,
            x: Window.width - 500, y: 40,
            font: 'SuperMario256.ttf',
            style: 'bold',
            size: 50,
            color: 'black',
            z: 10
        )
    end

    for enemy in @level_enemies
        for hitbox in @level_hitboxes
            if hitbox.contains?(enemy[1].x + enemy[1].width, enemy[1].y + enemy[1].height/2) || hitbox.contains?(enemy[1].x, enemy[1].y + enemy[1].height/2)
                enemy[2] *= -1
            end
        enemy[0].x += enemy[2]
        enemy[1].x += enemy[2]
        end
    end

    for enemy in @level_enemies
        if enemy[1].contains?(@mario.x + @mario.width/3, @mario.y + @mario.height) || enemy[1].contains?(@mario.x + (2*@mario.width)/3, @mario.y + @mario.height)
            enemy[0].remove
            enemy[1].remove
            @level_enemies.delete(enemy)
            @score += 5
            @score_text.remove
            @score_text = Text.new(
                "Score: " + @score.to_s,
                x: Window.width - 500, y: 40,
                font: 'SuperMario256.ttf',
                style: 'bold',
                size: 50,
                color: 'black',
                z: 10
            )
            @mario_velocity[1] = -5
        elsif enemy[1].contains?(@mario.x + @mario.width, @mario.y + @mario.height/2) || enemy[1].contains?(@mario.x, @mario.y + @mario.height/2)
            @mario_hp -= 1
            if @mario_hp == 0
                exit
            end
            reset_level()
        end
    end
    move_and_collide()
end

show