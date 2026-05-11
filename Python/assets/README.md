# MultiPlayerTest Assets

Put the template screenshots for the War3 multiplayer automation in this directory.

Required files:

- `lan_button.png`
- `create_game.png`
- `create_game2.png`
- `start_game.png`
- `room_list.png`: the first selectable room row/list area after the client enters LAN.
- `select_room.png`: the visual selected-room state after the room row is clicked.

Optional state probe:

- `join_game.png`: if present, the automation treats its disappearance after
  clicking `room_list.png` as "already joined the room", because Warcraft III
  can enter a LAN room directly on double-click.

Use PNG screenshots at the original Warcraft III window scale. The current
automation expects foreground Warcraft III windows and template matching only.
