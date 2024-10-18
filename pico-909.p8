pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--pico-909
--by ryan nein

function _init()
    inst_name = {"rd", "oh", "ch", "cl", "tm", "sn", "bd" }
    intervals = {16, 12, 8, 6}
    bar_colors = {6,5,6,5}
    instruments = {}
	beat_num = 16;

    space = 2
    space1 = 5

	-- y = ref inst_names
	for y=0, 6 do
		for i=1, beat_num do
			make_inst(y, i)
		end
	end
end


function _update60()
    player:update()
	tracker:update()
    for inst in all(instruments) do
        inst:update()
    end
end


function _draw()
    cls(5)

    --background:
    rectfill(14,0,19,20,0)
    rectfill(12,4,21,20,0)
    rectfill(98,0,100,20,0)
    rectfill(106,0,109,20,0)
    rect_round(0+space,10,127-space,127-10, 1, 15)
    rect_round(0+space1,10,127-space1,127-10, 1, 7)
    print("pico-909", 12, 22, 5)
    print("RYTHM COMPOSER", 60, 22, 5)

    for inst in all(instruments) do
        inst:draw()
    end
    player:draw()
	tracker:draw()
end



player = {
    x = 0,
    y = 0,
    w = 6,
    h = 6,
    index = 1,
    c=11,

    update = function(self)
        --movment
        if btnp(1) then
            self.index += 1
        elseif btnp(0) then
            self.index -= 1
        elseif btnp(3) then
			self.index += beat_num
		elseif btnp(2) then
			self.index -= beat_num
		end
        --clamp:
        self.index = mid(1, self.index, #instruments)

        --input
        if btnp(4) then
            if instruments[self.index].active then
                instruments[self.index].active = false
            else 
                instruments[self.index].active = true
            end
        end

        --sped change
        if btnp(5) then
            tracker.int_i += 1
            tracker.beat = 1
            tracker.timer = 0
            for inst in all(instruments) do
				inst.played = false
			end
            if tracker.int_i > #intervals then
                tracker.int_i = 1
            end
        end

        self.x = instruments[self.index].x-1
        self.y = instruments[self.index].y-1
    end,
    
    draw = function(self)
        rect(self.x, self.y, self.x+self.w,self.y+self.h, self.c)
    end
}

tracker = {
	x=0,
	y=36,
	r=2,
	c=9,
	start=0,
	max=80,
	padding = 28,
	spd=1,
    interval=4,
    int_i = 2,
    beat=1,
    timer=0,

	update = function(self)
        --speed from list:
        self.interval = intervals[self.int_i]


        if self.timer <= 0 then
            self.timer = self.interval
            self.beat +=1
            -- reset bar:
            if self.beat >= beat_num+1 then
                self.beat = 1
                for inst in all(instruments) do
                    inst.played = false
                end
            end
        end
        self.timer -= self.spd


        -- circle movment:
        self.x = ((self.beat-1)/beat_num)*self.max 

	end,
	draw = function(self)
		rect(self.padding+self.start, self.y, self.padding+self.start+self.max, self.y, 5)
		circfill(self.padding+self.x,self.y,self.r,self.c)

        print(self.beat, self.start+self.padding-10, self.y-2, 9)
        print("SPEED: " .. self.int_i, 80, 106, 5)
	end
}

function make_inst(_type, _index)
    local inst = {
        type = _type,
        index = _index,
        x = _index*4+32;
        y = ((_type+1)*8)+40,
        w = 4,
        h = 4,
        c = 6,
        name = "",
        x_margin = 10,
        active = false,
		sound = _type,
		played = false,

        update = function(self)
			if tracker.beat >= self.index and self.played == false and self.active then
				sfx(self.sound)
				self.played = true
			end
        end,

        draw = function(self)
            if self.active then
                rectfill(self.x, self.y, self.x+self.w, self.y+self.h, 11)
            end
            rect(self.x, self.y, self.x+self.w, self.y+self.h, self.c)
            print( self.name, 25, self.y, 9)
        end
    }
    inst.bar = flr((inst.index-1)/4)+1 --every 4
    inst.c = bar_colors[inst.bar] -- color set bar

    inst.name = inst_name[inst.type+1]    

    add(instruments, inst)
end


function rect_round(x,y,x2,y2,r,c)
    circfill(x+r,y+r,r,c)
    circfill(x2-r,y+r,r,c)
    circfill(x+r,y2-r,r,c)
    circfill(x2-r,y2-r,r,c)
    rectfill(x,y+r,x2,y2-r,c)
    rectfill(x+r,y,x2-r,y2,c)
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000100010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00010000297703076029730217101d71017710237101d7001d7001d7001d7001f700217000c6001570010600217001b600216001670001700017000070000700107002470031700157000c700137003370021700
000300003862031620266102a610226002c600006002a6002c6002d6002e600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100001832020340176300f6200b620086000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100003864031320006002a610343301470014700147001570016700187001b7001f700207002370023600266002c600316003460035600376003a6003b6000000000000000000000000000000000000000000
000100001b060200701d06018050100300c00007000040000b000057001c0001f000230002400024000230001c000190001400011000190000d3000f7000830009300000000b3000d3000e300103001330016300
0001000016070246701a06015040100400c0200c61013610193001f30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0001000007650117700d7700976006750047400373002720030100101000710037100471007710090100e0200a300167000c30015600196000d3000f7000830009300000000b3000d3000e300103001330016300
0001000027200232002c3002d300262002f2000330002700043000570008600023000470003300043000330004300073000c30015600196000d3000f7000830009300000000b3000d3000e300103001330016300
