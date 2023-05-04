function make_tower(pos1 : Position, radius : number, height : number, hollow: boolean) {
    //middle
    for (let i = 0; i <= height; i++) {
        shapes.circle(STONE_BRICKS, positions.add(pos1,pos(0,i,0)), radius, Axis.Y, ShapeOperation.Replace)
        if (hollow) {
            shapes.circle(AIR, positions.add(pos1, pos(0, i, 0)), radius-1, Axis.Y, ShapeOperation.Replace)
        }
    }
    //top
    shapes.circle(STONE_SLAB, positions.add(pos1, pos(0, height, 0)), radius + 1, Axis.Y, ShapeOperation.Replace)
    shapes.circle(CHISELED_STONE_BRICKS, positions.add(pos1, pos(0, height, 0)), radius, Axis.Y, ShapeOperation.Replace)
    shapes.circle(DARK_OAK_FENCE, positions.add(pos1, pos(0, height - 1, 0)), radius + 1, Axis.Y, ShapeOperation.Replace)
    shapes.circle(CHISELED_STONE_BRICKS, positions.add(pos1, pos(0, height - 1, 0)), radius, Axis.Y, ShapeOperation.Replace)
    shapes.circle(CHISELED_STONE_BRICKS, positions.add(pos1, pos(0, height + 1, 0)), radius+1, Axis.Y, ShapeOperation.Replace)
    shapes.circle(CHISELED_STONE_BRICKS, positions.add(pos1, pos(0, height + 2, 0)), radius+1, Axis.Y, ShapeOperation.Replace)
    shapes.circle(CHISELED_STONE_BRICKS, positions.add(pos1, pos(0, height + 3, 0)), radius + 1, Axis.Y, ShapeOperation.Replace)
    shapes.circle(CHISELED_STONE_BRICKS, positions.add(pos1, pos(0, height + 4, 0)), radius + 1, Axis.Y, ShapeOperation.Replace)

    //making cuts on top
    for (let i = -radius-1; i <= radius+1; i+=2) {
        blocks.fill(AIR, positions.add(pos1, pos(radius + 1, height + 3, i)), positions.add(pos1, pos(-radius-1, height + 4, i)))
        blocks.fill(AIR, positions.add(pos1, pos(i, height + 3, radius + 1)), positions.add(pos1, pos(i, height + 4, -radius-1)))
    }
    shapes.circle(AIR, positions.add(pos1, pos(0, height+4, 0)), radius - 1, Axis.Y, ShapeOperation.Replace)
    shapes.circle(AIR, positions.add(pos1, pos(0, height + 3, 0)), radius - 1, Axis.Y, ShapeOperation.Replace)
}

function make_moat_and_bridge(){
    //Water and ground
    shapes.circle(WATER, world(0, -1, -65), 60, Axis.Y, ShapeOperation.Replace)
    shapes.circle(GRASS, world(0, -1, -65), 50, Axis.Y, ShapeOperation.Replace)

    //Bridge
    blocks.fill(DARK_OAK_WOOD_SLAB, world(-3, 1, -6), world(3, 1, -15))
    shapes.line(blocks.blockWithData(DARK_OAK_WOOD_STAIRS, 3), world(-3, 0, -5), world(3, 0, -5))
    shapes.line(blocks.blockWithData(DARK_OAK_WOOD_STAIRS, 2), world(-3, 0, -16), world(3, 0, -16))

    blocks.fill(DARK_OAK_FENCE, world(-4, 0, -6), world(-4, 1, -15))
    blocks.fill(DARK_OAK_FENCE, world(4, 0, -6), world(4, 1, -15))

    shapes.line(17, world(-4, -1, -6), world(-4, 2, -6))
    shapes.line(17, world(4, -1, -6), world(4, 2, -6))
    shapes.line(17, world(-4, -1, -15), world(-4, 2, -15))
    shapes.line(17, world(4, -1, -15), world(4, 2, -15))

    shapes.line(17, world(-4, -1, -9), world(-4, 3, -9))
    shapes.line(17, world(4, -1, -9), world(4, 3, -9))
    shapes.line(17, world(-4, -1, -12), world(-4, 3, -12))
    shapes.line(17, world(4, -1, -12), world(4, 3, -12))

    blocks.place(TORCH, world(-4, 3, -6))
    blocks.place(TORCH, world(4, 3, -6))
    blocks.place(TORCH, world(-4, 3, -15))
    blocks.place(TORCH, world(4, 3, -15))
}

function make_wall(p1:Position, p2:Position, height:number) {
    //lines from point 1 to point 2
    for (let i = 0; i < height; i++) {
        shapes.line(STONE_BRICKS, positions.add(p1, pos(0, i, 0)), positions.add(p2, pos(0, i, 0)))
    }
}


function make_gate(center: Position, radius: number, fence:Block, ground: Block) {
    //circle gate
    shapes.circle(fence, center, radius, Axis.Z, ShapeOperation.Replace)
    shapes.circle(CHISELED_STONE_BRICKS, positions.add(center, pos(0, 0, -1)), radius+2, Axis.Z, ShapeOperation.Replace)
    shapes.circle(CHISELED_STONE_BRICKS, positions.add(center, pos(0, 0, 1)), radius+2, Axis.Z, ShapeOperation.Replace)
    shapes.circle(AIR, positions.add(center, pos(0, 0, -1)), radius, Axis.Z, ShapeOperation.Replace)
    shapes.circle(AIR, positions.add(center, pos(0, 0, 1)), radius, Axis.Z, ShapeOperation.Replace)
    blocks.fill(AIR, positions.add(center, pos(-radius / 2, 0, 0)), positions.add(center, pos(radius / 2, radius / 2, 0)))
    blocks.fill(ground, positions.add(center, pos(-radius, 0, -1)), positions.add(center, pos(radius, 0, 1)))
}

function make_stairs(p1:Position, p2:Position, width:number) {
    //placing stairs and clearing path for stairs
    for (let i = -width/2; i <= width/2; i++) {
        shapes.line(AIR, positions.add(p1, pos(i, 1, 0)), positions.add(p2, pos(i, 1, 0)))
        shapes.line(AIR, positions.add(p1, pos(i, 2, 0)), positions.add(p2, pos(i, 2, 0)))
        shapes.line(AIR, positions.add(p1, pos(i, 3, 0)), positions.add(p2, pos(i, 3, 0)))
        shapes.line(AIR, positions.add(p1, pos(i, 4, 0)), positions.add(p2, pos(i, 4, 0)))
        shapes.line(AIR, positions.add(p1, pos(i, 5, 0)), positions.add(p2, pos(i, 5, 0)))
        shapes.line(blocks.blockWithData(DARK_OAK_WOOD_STAIRS, 3), positions.add(p1, pos(i, 0, 0)), positions.add(p2, pos(i, 0, 0)))
        
    }
}

function make_purple_pit(p1:Position, width:number){
    //glowing purple lava pit 
    for (let i = 0; i < 8; i += 2) {
        shapes.circle(PURPLE_STAINED_GLASS, positions.add(p1, pos(0, -i, 0)), width, Axis.Y, ShapeOperation.Replace)
        shapes.circle(MAGENTA_STAINED_GLASS, positions.add(p1, pos(0, -i - 1, 0)), width, Axis.Y, ShapeOperation.Replace)
    }
    shapes.circle(LAVA, positions.add(p1, pos(0, -8, 0)), width, Axis.Y, ShapeOperation.Replace)
}

function make_fountain(p1:Position, width: number){
    shapes.circle(COBBLESTONE, p1, width, Axis.Y, ShapeOperation.Replace)
    shapes.circle(STONE_SLAB, positions.add(p1, pos(0, 1, 0)), width+1, Axis.Y, ShapeOperation.Replace)
    shapes.circle(AIR, positions.add(p1, pos(0, 1, 0)), width, Axis.Y, ShapeOperation.Replace)
    blocks.fill(CHISELED_STONE_BRICKS, positions.add(p1, pos(0, 5, 1)), positions.add(p1, pos(0, 0, -1)))
    blocks.fill(CHISELED_STONE_BRICKS, positions.add(p1, pos(1, 5, 0)), positions.add(p1, pos(-1, 0, 0)))
    blocks.place(WATER, positions.add(p1, pos(0, 6, 0)))
}

function make_castle() {
    const tower_positions = [world(-20, 0, -26), world(20, 0, -26), world(-40, 0, -60), world(40, 0, -60), world(-20, 0, -100), world(20, 0, -100)]
    make_wall(tower_positions[0], tower_positions[1], 15)
    make_wall(tower_positions[0], tower_positions[2], 15)
    make_wall(tower_positions[1], tower_positions[3], 15)
    make_wall(tower_positions[4], tower_positions[5], 40)
    make_wall(tower_positions[2], tower_positions[3], 30)
    make_tower(tower_positions[0], 6, 15,false)
    make_tower(tower_positions[1], 6, 15,false)
    make_tower(tower_positions[2], 6, 30,false)
    make_tower(tower_positions[3], 6, 30,false)
    make_tower(world(0, -1, -95), 20, 15,false)
    make_tower(world(-20, -1, -75), 10, 8,false)
    make_tower(world(20, -1, -75), 10, 8,false)
    make_wall(tower_positions[2], tower_positions[4], 30)
    make_wall(tower_positions[3], tower_positions[5], 30)
    make_tower(tower_positions[4], 10, 50,true)
    make_tower(tower_positions[5], 10, 50,true)
    make_gate(world(0, -1, -26),10,DARK_OAK_FENCE,GRASS)
    make_gate(world(0, -1, -60), 25,DARK_OAK_FENCE,GRASS)
    make_gate(world(0, 16, -100), 10, AIR,STONE_BRICKS)
    make_stairs(world(0,0,-74),world(0,16,-90),6)
    blocks.fill(CHISELED_NETHER_BRICKS, world(-3, -1, -17), world(3, -1, -90))
    make_purple_pit(world(0,-1,-80),15)
    make_fountain(world(25, -1, -50), 5)
    make_fountain(world(-25, -1, -50), 5)
    blocks.fill(AIR,world(-17,23,-91), world(17,17,-95))
    blocks.fill(AIR, world(17, 17, -109), world(23, 23, -110))
    blocks.fill(AIR, world(-17, 17, -109), world(-23, 23, -110))
    blocks.fill(AIR, world(-29, 17, -97), world(-30, 23, -103))
    blocks.fill(AIR, world(29, 17, -97), world(30, 23, -103))
    shapes.line(COBBLESTONE_WALL, world(16, 17, -109), world(24, 17, -109))
    shapes.line(COBBLESTONE_WALL, world(-16, 17, -109), world(-24, 17, -109))
    shapes.line(COBBLESTONE_WALL, world(29, 17, -96), world(29, 17, -104))
    shapes.line(COBBLESTONE_WALL, world(-29, 17, -96), world(-29, 17, -104))
    shapes.circle(PLANKS_DARK_OAK, positions.add(tower_positions[4], pos(0, 16, 0)), 9, Axis.Y, ShapeOperation.Replace)
    shapes.circle(PLANKS_DARK_OAK, positions.add(tower_positions[5], pos(0, 16, 0)), 9, Axis.Y, ShapeOperation.Replace)
    blocks.fill(LADDER, world(20, 17, -91), world(20, 55, -91))
    blocks.fill(blocks.blockWithData(LADDER, 2), world(20, 17, -91), world(20, 55, -91))
    blocks.fill(blocks.blockWithData(LADDER, 2), world(-20, 17, -91), world(-20, 55, -91))
}

function grow_trees(pos1:Position, how_many:number){
    //using agent to place and grow trees
    agent.teleport(pos1, SOUTH)
    agent.setItem(OAK_SAPLING, 32, 1)
    agent.setItem(BONE_MEAL, 32, 2)
    agent.setSlot(1)

    for (let i = 0; i < how_many; i++) {
        agent.place(FORWARD)
        agent.move(FORWARD,5)
    }
    agent.setSlot(2)
    for (let i = 0; i < how_many; i++) {
        agent.move(BACK, 5)
        while (agent.inspect(AgentInspection.Block, FORWARD) != 17){
            agent.place(FORWARD)
        }
    }
}

function grow_grass(pos1: Position, how_many: number) {
    //using agent to plant grass
    agent.teleport(pos1, SOUTH)
    agent.setItem(BONE_MEAL, 32, 1)
    agent.setSlot(1)
    agent.setAssist(PLACE_ON_MOVE,true)

    for (let i = 0; i < how_many; i++) {
        agent.move(FORWARD, 5)
    }
    
}

make_moat_and_bridge()
make_castle()
//teleporting because of agent work range
player.teleport(world(0, 0, -45))
grow_trees(world(10, 0, -55),5)
grow_trees(world(-10, 0, -55), 5)
grow_grass(world(-7, 0, -65), 7)
grow_grass(world(7, 0, -65), 7)
player.teleport(world(0, 0, 0))
agent.teleportToPlayer()