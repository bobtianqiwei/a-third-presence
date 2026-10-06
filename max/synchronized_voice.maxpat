{
  "patcher": {
    "fileversion": 1,
    "rect": [
      0,
      0,
      850,
      450
    ],
    "boxes": [
      {
        "box": {
          "id": "credit",
          "maxclass": "comment",
          "text": "synchronized_voice.maxpat developed by Bob Tianqi Wei",
          "patching_rect": [
            25,
            10,
            180,
            22
          ]
        }
      },
      {
        "box": {
          "id": "time",
          "maxclass": "newobj",
          "text": "in~ 1",
          "patching_rect": [
            25,
            55,
            180,
            22
          ]
        }
      },
      {
        "box": {
          "id": "controls",
          "maxclass": "newobj",
          "text": "in 1",
          "patching_rect": [
            250,
            55,
            180,
            22
          ]
        }
      },
      {
        "box": {
          "id": "route",
          "maxclass": "newobj",
          "text": "route setbuf gain mono duration",
          "patching_rect": [
            250,
            95,
            180,
            22
          ]
        }
      },
      {
        "box": {
          "id": "setbuf",
          "maxclass": "newobj",
          "text": "prepend set",
          "patching_rect": [
            250,
            140,
            180,
            22
          ]
        }
      },
      {
        "box": {
          "id": "player",
          "maxclass": "newobj",
          "text": "play~ unused 2",
          "patching_rect": [
            25,
            180,
            180,
            22
          ]
        }
      },
      {
        "box": {
          "id": "gainpack",
          "maxclass": "newobj",
          "text": "pack 0. 50",
          "patching_rect": [
            440,
            140,
            180,
            22
          ]
        }
      },
      {
        "box": {
          "id": "gain",
          "maxclass": "newobj",
          "text": "line~ 0.",
          "patching_rect": [
            440,
            180,
            180,
            22
          ]
        }
      },
      {
        "box": {
          "id": "mono",
          "maxclass": "newobj",
          "text": "+ 1",
          "patching_rect": [
            620,
            140,
            180,
            22
          ]
        }
      },
      {
        "box": {
          "id": "right",
          "maxclass": "newobj",
          "text": "selector~ 2",
          "patching_rect": [
            180,
            230,
            180,
            22
          ]
        }
      },
      {
        "box": {
          "id": "range",
          "maxclass": "newobj",
          "text": "<~ 1.",
          "patching_rect": [
            25,
            270,
            180,
            22
          ]
        }
      },
      {
        "box": {
          "id": "gate",
          "maxclass": "newobj",
          "text": "*~",
          "patching_rect": [
            440,
            270,
            180,
            22
          ]
        }
      },
      {
        "box": {
          "id": "left",
          "maxclass": "newobj",
          "text": "*~",
          "patching_rect": [
            25,
            320,
            180,
            22
          ]
        }
      },
      {
        "box": {
          "id": "rightgain",
          "maxclass": "newobj",
          "text": "*~",
          "patching_rect": [
            180,
            320,
            180,
            22
          ]
        }
      },
      {
        "box": {
          "id": "outL",
          "maxclass": "newobj",
          "text": "out~ 1",
          "patching_rect": [
            25,
            370,
            180,
            22
          ]
        }
      },
      {
        "box": {
          "id": "outR",
          "maxclass": "newobj",
          "text": "out~ 2",
          "patching_rect": [
            180,
            370,
            180,
            22
          ]
        }
      }
    ],
    "lines": [
      {
        "patchline": {
          "source": [
            "controls",
            0
          ],
          "destination": [
            "route",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "route",
            0
          ],
          "destination": [
            "setbuf",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "setbuf",
            0
          ],
          "destination": [
            "player",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "time",
            0
          ],
          "destination": [
            "player",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "route",
            1
          ],
          "destination": [
            "gainpack",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "gainpack",
            0
          ],
          "destination": [
            "gain",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "route",
            2
          ],
          "destination": [
            "mono",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "mono",
            0
          ],
          "destination": [
            "right",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "player",
            1
          ],
          "destination": [
            "right",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "player",
            0
          ],
          "destination": [
            "right",
            2
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "route",
            3
          ],
          "destination": [
            "range",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "time",
            0
          ],
          "destination": [
            "range",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "range",
            0
          ],
          "destination": [
            "gate",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "gain",
            0
          ],
          "destination": [
            "gate",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "player",
            0
          ],
          "destination": [
            "left",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "right",
            0
          ],
          "destination": [
            "rightgain",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "gate",
            0
          ],
          "destination": [
            "left",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "gate",
            0
          ],
          "destination": [
            "rightgain",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "left",
            0
          ],
          "destination": [
            "outL",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "rightgain",
            0
          ],
          "destination": [
            "outR",
            0
          ]
        }
      }
    ]
  }
}
