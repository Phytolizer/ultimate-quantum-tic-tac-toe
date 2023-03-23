#include "game.h"

#include <stb_ds.h>
#include <string.h>

#include "cutil.h"

void game_init(struct game* game) {
  memset(game, 0, sizeof(struct game));
}

void game_free(struct game* game) {
  for (size_t i = 0; i < ARRAY_LEN(game->boards); i++) {
    for (size_t j = 0; j < ARRAY_LEN(game->boards[i].squares); j++) {
      if (game->boards[i].squares[j].state == SQUARE_STATE_ENTANGLED) {
        stbds_arrfree(game->boards[i].squares[j].get.entangled);
      }
    }
  }
}

void game_handle_event(struct game* game, SDL_Event event) {
  switch (event.type) {}
}
