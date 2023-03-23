#include <SDL.h>
#include <cairo/cairo.h>
#include <stb_ds.h>
#include <stdbool.h>

#include "game.h"

enum {
  INITIAL_WIDTH = 1280,
  INITIAL_HEIGHT = 720,
};

int main(void) {
  SDL_Init(SDL_INIT_VIDEO);

  SDL_Window* window;
  SDL_Renderer* renderer;
  SDL_CreateWindowAndRenderer(
    INITIAL_WIDTH,
    INITIAL_HEIGHT,
    0,
    &window,
    &renderer
  );
  SDL_SetWindowTitle(window, "Ultimate Quantum Tic-Tac-Toe");

  struct game game;
  game_init(&game);

  bool done = false;
  while (!done) {
    SDL_Event event;
    while (SDL_PollEvent(&event)) {
      switch (event.type) {
        case SDL_QUIT:
          done = true;
          break;
      }
    }

    SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
    SDL_RenderClear(renderer);
    SDL_RenderPresent(renderer);
  }

  game_free(&game);
  SDL_Quit();
}
