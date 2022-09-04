rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))
SOURCE=$(call rwildcard,.,*.c)

compile:
	@clang \
		-Ofast -Wall -Wextra --target=wasm32 --no-standard-libraries -Wno-unused-parameter -Wno-switch\
		-Wl,--no-entry -Wl,--export-dynamic \
		-o build/sim.wasm \
		$(SOURCE)

js:
	@uglifyjs \
		./src/js/ui/primitives/vec2.js \
		./src/js/ui/primitives/point.js \
		./src/js/ui/primitives/primitive.js \
		./src/js/ui/primitives/drawable.js \
		./src/js/ui/primitives/glyphs.js \
		./src/js/ui/eventhandler.js \
		./src/js/ui/elements/element.js \
		./src/js/ui/elements/textnode.js \
		./src/js/ui/elements/button.js \
		./src/js/tools/paint.js \
		./src/js/tools/erase.js \
		./src/js/tools/line.js \
		./src/js/tools/wind.js \
		./src/js/glue.js \
		./src/js/elements.js \
		./src/js/lib/pako.js \
		./src/js/io.js \
		-o ./build/glue.min.js --compress --mangle #--source-map url=glue.min.js.map

	@cp ./src/static/* ./build

clean:
	@rm -f ./build/*
