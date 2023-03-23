cmake_minimum_required(VERSION 3.23)

project(
  "Ultimate Quantum Tic-Tac-Toe"
  LANGUAGES C
  VERSION "0.1.0"
)

find_package(SDL2 REQUIRED)
find_package(Stb REQUIRED)

add_executable(uqttt src/main.c src/game.c src/stbds.c)
target_compile_definitions(uqttt PRIVATE STBDS_NO_SHORT_NAMES)
target_link_libraries(
  uqttt
  PRIVATE $<TARGET_NAME_IF_EXISTS:SDL2::SDL2main>
          $<IF:$<TARGET_EXISTS:SDL2::SDL2>,SDL2::SDL2,SDL2::SDL2-static> cairo
)
target_include_directories(uqttt PRIVATE ${Stb_INCLUDE_DIR})
