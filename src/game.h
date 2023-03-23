#pragma once

#include <SDL.h>
#include <stddef.h>

enum player { PLAYER_X, PLAYER_O };

struct play {
  size_t move_number;
  enum player player;
};

enum square_state {
#define X(x) SQUARE_STATE_##x,
  X(ENTANGLED) X(COLLAPSED)
#undef X
};

struct square {
  enum square_state state;
  union {
    struct play* entangled;
    struct play collapsed;
  } get;
};

struct board {
  struct square squares[3 * 3];
};

struct game {
  struct board boards[3 * 3];
};

void game_init(struct game* game);
void game_free(struct game* game);

void game_handle_event(struct game* game, SDL_Event event);
