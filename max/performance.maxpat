{
  "patcher": {
    "fileversion": 1,
    "appversion": {
      "major": 8,
      "minor": 6,
      "revision": 0,
      "architecture": "x64",
      "modernui": 1
    },
    "rect": [
      0,
      0,
      1100,
      820
    ],
    "openinpresentation": 1,
    "default_fontsize": 12,
    "default_fontname": "Arial",
    "boxes": [
      {
        "box": {
          "id": "credit",
          "maxclass": "comment",
          "patching_rect": [
            25,
            8,
            600,
            22
          ],
          "text": "performance.maxpat developed by Bob Tianqi Wei",
          "presentation": 0,
          "presentation_rect": [
            25,
            8,
            600,
            24
          ]
        }
      },
      {
        "box": {
          "id": "title",
          "maxclass": "comment",
          "patching_rect": [
            25,
            38,
            600,
            22
          ],
          "text": "A Third Presence",
          "presentation": 1,
          "presentation_rect": [
            25,
            18,
            260,
            28
          ],
          "fontsize": 20
        }
      },
      {
        "box": {
          "id": "concept",
          "maxclass": "comment",
          "patching_rect": [
            25,
            69,
            700,
            22
          ],
          "text": "EEG and AI as speculative mediators of shared presence.",
          "presentation": 0,
          "presentation_rect": [
            25,
            69,
            700,
            24
          ]
        }
      },
      {
        "box": {
          "id": "udp",
          "maxclass": "newobj",
          "patching_rect": [
            30,
            620,
            180,
            22
          ],
          "text": "udpreceive 9000"
        }
      },
      {
        "box": {
          "id": "oscroute",
          "maxclass": "newobj",
          "patching_rect": [
            30,
            665,
            1650,
            22
          ],
          "text": "route /sound/position /eeg/a/attention /eeg/a/meditation /eeg/a/signal /eeg/b/attention /eeg/b/meditation /eeg/b/signal /eeg/a/device /eeg/b/device /eeg/a/status /eeg/b/status /eeg/devices /eeg/control/status /session/status /session/prompt /session/complete /session/prompt_a /session/mode /session/countdown /session/progress /session/play /session/position /session/automatic",
          "numoutlets": 24
        }
      },
      {
        "box": {
          "id": "nav",
          "maxclass": "newobj",
          "patching_rect": [
            380,
            730,
            190,
            22
          ],
          "text": "js navigation.js #0",
          "numoutlets": 10
        }
      },
      {
        "box": {
          "id": "oscpos",
          "maxclass": "newobj",
          "patching_rect": [
            30,
            710,
            180,
            22
          ],
          "text": "prepend position"
        }
      },
      {
        "box": {
          "id": "participant_a",
          "maxclass": "comment",
          "patching_rect": [
            25,
            115,
            200,
            22
          ],
          "text": "Participant A",
          "presentation": 1,
          "presentation_rect": [
            25,
            110,
            490,
            24
          ]
        }
      },
      {
        "box": {
          "id": "a_attention_label",
          "maxclass": "comment",
          "patching_rect": [
            25,
            150,
            110,
            22
          ],
          "text": "Attention",
          "presentation": 1,
          "presentation_rect": [
            25,
            144,
            75,
            24
          ]
        }
      },
      {
        "box": {
          "id": "a_attention",
          "maxclass": "flonum",
          "patching_rect": [
            145,
            150,
            85,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            105,
            144,
            65,
            24
          ]
        }
      },
      {
        "box": {
          "id": "a_meditation_label",
          "maxclass": "comment",
          "patching_rect": [
            25,
            190,
            110,
            22
          ],
          "text": "Meditation",
          "presentation": 1,
          "presentation_rect": [
            190,
            144,
            80,
            24
          ]
        }
      },
      {
        "box": {
          "id": "a_meditation",
          "maxclass": "flonum",
          "patching_rect": [
            145,
            190,
            85,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            275,
            144,
            65,
            24
          ]
        }
      },
      {
        "box": {
          "id": "a_signal_label",
          "maxclass": "comment",
          "patching_rect": [
            25,
            230,
            110,
            22
          ],
          "text": "Signal",
          "presentation": 1,
          "presentation_rect": [
            360,
            144,
            55,
            24
          ]
        }
      },
      {
        "box": {
          "id": "a_signal",
          "maxclass": "number",
          "patching_rect": [
            145,
            230,
            85,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            420,
            144,
            65,
            24
          ]
        }
      },
      {
        "box": {
          "id": "participant_b",
          "maxclass": "comment",
          "patching_rect": [
            615,
            115,
            200,
            22
          ],
          "text": "Participant B",
          "presentation": 1,
          "presentation_rect": [
            545,
            110,
            500,
            24
          ]
        }
      },
      {
        "box": {
          "id": "b_attention_label",
          "maxclass": "comment",
          "patching_rect": [
            615,
            150,
            110,
            22
          ],
          "text": "Attention",
          "presentation": 1,
          "presentation_rect": [
            545,
            144,
            75,
            24
          ]
        }
      },
      {
        "box": {
          "id": "b_attention",
          "maxclass": "flonum",
          "patching_rect": [
            735,
            150,
            85,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            625,
            144,
            65,
            24
          ]
        }
      },
      {
        "box": {
          "id": "b_meditation_label",
          "maxclass": "comment",
          "patching_rect": [
            615,
            190,
            110,
            22
          ],
          "text": "Meditation",
          "presentation": 1,
          "presentation_rect": [
            710,
            144,
            80,
            24
          ]
        }
      },
      {
        "box": {
          "id": "b_meditation",
          "maxclass": "flonum",
          "patching_rect": [
            735,
            190,
            85,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            795,
            144,
            65,
            24
          ]
        }
      },
      {
        "box": {
          "id": "b_signal_label",
          "maxclass": "comment",
          "patching_rect": [
            615,
            230,
            110,
            22
          ],
          "text": "Signal",
          "presentation": 1,
          "presentation_rect": [
            880,
            144,
            55,
            24
          ]
        }
      },
      {
        "box": {
          "id": "b_signal",
          "maxclass": "number",
          "patching_rect": [
            735,
            230,
            85,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            940,
            144,
            65,
            24
          ]
        }
      },
      {
        "box": {
          "id": "position_label",
          "maxclass": "comment",
          "patching_rect": [
            265,
            120,
            300,
            22
          ],
          "text": "Position",
          "presentation": 1,
          "presentation_rect": [
            25,
            300,
            85,
            24
          ]
        }
      },
      {
        "box": {
          "id": "position",
          "maxclass": "flonum",
          "patching_rect": [
            365,
            151,
            85,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            580,
            300,
            75,
            24
          ]
        }
      },
      {
        "box": {
          "id": "slider",
          "maxclass": "slider",
          "patching_rect": [
            265,
            192,
            290,
            24
          ],
          "size": 1.001,
          "floatoutput": 1,
          "presentation": 1,
          "presentation_rect": [
            115,
            300,
            450,
            24
          ]
        }
      },
      {
        "box": {
          "id": "manual",
          "maxclass": "newobj",
          "patching_rect": [
            270,
            660,
            180,
            22
          ],
          "text": "prepend manual"
        }
      },
      {
        "box": {
          "id": "slider_set",
          "maxclass": "newobj",
          "patching_rect": [
            270,
            620,
            180,
            22
          ],
          "text": "prepend set"
        }
      },
      {
        "box": {
          "id": "tele",
          "maxclass": "newobj",
          "patching_rect": [
            30,
            790,
            1050,
            22
          ],
          "text": "route position continuous left right crossfade pair count folder status audio dsp master transport"
        }
      },
      {
        "box": {
          "id": "continuous_label",
          "maxclass": "comment",
          "patching_rect": [
            25,
            300,
            190,
            22
          ],
          "text": "Continuous Index",
          "presentation": 0,
          "presentation_rect": [
            25,
            575,
            190,
            24
          ]
        }
      },
      {
        "box": {
          "id": "continuous",
          "maxclass": "flonum",
          "patching_rect": [
            25,
            327,
            85,
            22
          ],
          "presentation": 0,
          "presentation_rect": [
            25,
            602,
            85,
            24
          ]
        }
      },
      {
        "box": {
          "id": "left_label",
          "maxclass": "comment",
          "patching_rect": [
            265,
            300,
            190,
            22
          ],
          "text": "Left Index",
          "presentation": 0,
          "presentation_rect": [
            265,
            575,
            190,
            24
          ]
        }
      },
      {
        "box": {
          "id": "left",
          "maxclass": "number",
          "patching_rect": [
            265,
            327,
            85,
            22
          ],
          "presentation": 0,
          "presentation_rect": [
            265,
            602,
            85,
            24
          ]
        }
      },
      {
        "box": {
          "id": "right_label",
          "maxclass": "comment",
          "patching_rect": [
            480,
            300,
            190,
            22
          ],
          "text": "Right Index",
          "presentation": 0,
          "presentation_rect": [
            480,
            575,
            190,
            24
          ]
        }
      },
      {
        "box": {
          "id": "right",
          "maxclass": "number",
          "patching_rect": [
            480,
            327,
            85,
            22
          ],
          "presentation": 0,
          "presentation_rect": [
            480,
            602,
            85,
            24
          ]
        }
      },
      {
        "box": {
          "id": "crossfade_label",
          "maxclass": "comment",
          "patching_rect": [
            690,
            300,
            190,
            22
          ],
          "text": "Crossfade",
          "presentation": 0,
          "presentation_rect": [
            690,
            575,
            190,
            24
          ]
        }
      },
      {
        "box": {
          "id": "crossfade",
          "maxclass": "flonum",
          "patching_rect": [
            690,
            327,
            85,
            22
          ],
          "presentation": 0,
          "presentation_rect": [
            690,
            602,
            85,
            24
          ]
        }
      },
      {
        "box": {
          "id": "count_label",
          "maxclass": "comment",
          "patching_rect": [
            25,
            360,
            190,
            22
          ],
          "text": "Audio Files",
          "presentation": 0,
          "presentation_rect": [
            25,
            635,
            190,
            24
          ]
        }
      },
      {
        "box": {
          "id": "count",
          "maxclass": "number",
          "patching_rect": [
            25,
            387,
            85,
            22
          ],
          "presentation": 0,
          "presentation_rect": [
            25,
            662,
            85,
            24
          ]
        }
      },
      {
        "box": {
          "id": "pair_label",
          "maxclass": "comment",
          "patching_rect": [
            265,
            360,
            210,
            22
          ],
          "text": "Current Sound Pair",
          "presentation": 0,
          "presentation_rect": [
            265,
            635,
            210,
            24
          ]
        }
      },
      {
        "box": {
          "id": "pair",
          "maxclass": "message",
          "patching_rect": [
            265,
            390,
            240,
            22
          ],
          "text": "",
          "presentation": 0,
          "presentation_rect": [
            265,
            665,
            240,
            24
          ]
        }
      },
      {
        "box": {
          "id": "set_pair",
          "maxclass": "newobj",
          "patching_rect": [
            265,
            917,
            180,
            22
          ],
          "text": "prepend set"
        }
      },
      {
        "box": {
          "id": "folder_label",
          "maxclass": "comment",
          "patching_rect": [
            25,
            448,
            200,
            22
          ],
          "text": "Audio Folder",
          "presentation": 0,
          "presentation_rect": [
            25,
            723,
            200,
            24
          ]
        }
      },
      {
        "box": {
          "id": "folder",
          "maxclass": "message",
          "patching_rect": [
            25,
            478,
            780,
            22
          ],
          "text": "",
          "presentation": 0,
          "presentation_rect": [
            25,
            753,
            780,
            24
          ]
        }
      },
      {
        "box": {
          "id": "set_folder",
          "maxclass": "newobj",
          "patching_rect": [
            25,
            926,
            180,
            22
          ],
          "text": "prepend set"
        }
      },
      {
        "box": {
          "id": "status_label",
          "maxclass": "comment",
          "patching_rect": [
            25,
            525,
            200,
            22
          ],
          "text": "OSC Status",
          "presentation": 0,
          "presentation_rect": [
            25,
            800,
            200,
            24
          ]
        }
      },
      {
        "box": {
          "id": "status",
          "maxclass": "message",
          "patching_rect": [
            140,
            525,
            400,
            22
          ],
          "text": "",
          "presentation": 0,
          "presentation_rect": [
            140,
            800,
            400,
            24
          ]
        }
      },
      {
        "box": {
          "id": "set_status",
          "maxclass": "newobj",
          "patching_rect": [
            140,
            935,
            180,
            22
          ],
          "text": "prepend set"
        }
      },
      {
        "box": {
          "id": "audio",
          "maxclass": "message",
          "patching_rect": [
            25,
            563,
            780,
            22
          ],
          "text": "",
          "presentation": 1,
          "presentation_rect": [
            25,
            377,
            1020,
            28
          ]
        }
      },
      {
        "box": {
          "id": "set_audio",
          "maxclass": "newobj",
          "patching_rect": [
            25,
            941,
            180,
            22
          ],
          "text": "prepend set"
        }
      },
      {
        "box": {
          "id": "start",
          "maxclass": "textbutton",
          "patching_rect": [
            25,
            245,
            80,
            22
          ],
          "text": "START",
          "presentation": 1,
          "presentation_rect": [
            25,
            340,
            80,
            28
          ],
          "mode": 0,
          "texton": "START",
          "numoutlets": 3,
          "outlettype": [
            "bang",
            "",
            "int"
          ],
          "parameter_enable": 0,
          "active": 1,
          "ignoreclick": 0,
          "outputmode": 0,
          "numinlets": 1
        }
      },
      {
        "box": {
          "id": "start_trigger",
          "maxclass": "newobj",
          "patching_rect": [
            25,
            740,
            45,
            22
          ],
          "text": "t b"
        }
      },
      {
        "box": {
          "id": "start_msg",
          "maxclass": "message",
          "patching_rect": [
            25,
            770,
            80,
            22
          ],
          "text": "start"
        }
      },
      {
        "box": {
          "id": "stop",
          "maxclass": "textbutton",
          "patching_rect": [
            125,
            245,
            80,
            22
          ],
          "text": "STOP",
          "presentation": 1,
          "presentation_rect": [
            120,
            340,
            80,
            28
          ],
          "mode": 0,
          "texton": "STOP",
          "numoutlets": 3,
          "outlettype": [
            "bang",
            "",
            "int"
          ],
          "parameter_enable": 0,
          "active": 1,
          "ignoreclick": 0,
          "outputmode": 0,
          "numinlets": 1
        }
      },
      {
        "box": {
          "id": "stop_trigger",
          "maxclass": "newobj",
          "patching_rect": [
            125,
            740,
            45,
            22
          ],
          "text": "t b"
        }
      },
      {
        "box": {
          "id": "stop_msg",
          "maxclass": "message",
          "patching_rect": [
            125,
            770,
            80,
            22
          ],
          "text": "stop"
        }
      },
      {
        "box": {
          "id": "reload",
          "maxclass": "textbutton",
          "patching_rect": [
            235,
            245,
            165,
            22
          ],
          "text": "Reload Audio",
          "presentation": 1,
          "presentation_rect": [
            220,
            340,
            150,
            28
          ],
          "mode": 0,
          "texton": "Reload Audio",
          "numoutlets": 3,
          "outlettype": [
            "bang",
            "",
            "int"
          ],
          "parameter_enable": 0,
          "active": 1,
          "ignoreclick": 0,
          "outputmode": 0,
          "numinlets": 1
        }
      },
      {
        "box": {
          "id": "reload_trigger",
          "maxclass": "newobj",
          "patching_rect": [
            235,
            740,
            45,
            22
          ],
          "text": "t b"
        }
      },
      {
        "box": {
          "id": "reload_msg",
          "maxclass": "message",
          "patching_rect": [
            235,
            770,
            80,
            22
          ],
          "text": "reload"
        }
      },
      {
        "box": {
          "id": "choose",
          "maxclass": "textbutton",
          "patching_rect": [
            410,
            245,
            165,
            22
          ],
          "text": "Choose Audio Folder",
          "presentation": 1,
          "presentation_rect": [
            385,
            340,
            190,
            28
          ],
          "mode": 0,
          "texton": "Choose Audio Folder",
          "numoutlets": 3,
          "outlettype": [
            "bang",
            "",
            "int"
          ],
          "parameter_enable": 0,
          "active": 1,
          "ignoreclick": 0,
          "outputmode": 0,
          "numinlets": 1
        }
      },
      {
        "box": {
          "id": "choose_trigger",
          "maxclass": "newobj",
          "patching_rect": [
            680,
            620,
            180,
            22
          ],
          "text": "t b"
        }
      },
      {
        "box": {
          "id": "dialog",
          "maxclass": "newobj",
          "patching_rect": [
            680,
            660,
            180,
            22
          ],
          "text": "opendialog fold"
        }
      },
      {
        "box": {
          "id": "folder_pre",
          "maxclass": "newobj",
          "patching_rect": [
            680,
            700,
            180,
            22
          ],
          "text": "prepend folder"
        }
      },
      {
        "box": {
          "id": "master_label",
          "maxclass": "comment",
          "patching_rect": [
            580,
            245,
            230,
            22
          ],
          "text": "Volume",
          "presentation": 1,
          "presentation_rect": [
            700,
            300,
            80,
            24
          ]
        }
      },
      {
        "box": {
          "id": "master",
          "maxclass": "flonum",
          "patching_rect": [
            690,
            277,
            85,
            22
          ],
          "minimum": 0.0,
          "maximum": 1.0,
          "presentation": 1,
          "presentation_rect": [
            785,
            300,
            75,
            24
          ]
        }
      },
      {
        "box": {
          "id": "masterclip",
          "maxclass": "newobj",
          "patching_rect": [
            950,
            1000,
            180,
            22
          ],
          "text": "clip 0. 1."
        }
      },
      {
        "box": {
          "id": "masterpack",
          "maxclass": "newobj",
          "patching_rect": [
            950,
            1040,
            180,
            22
          ],
          "text": "pack 0. 100"
        }
      },
      {
        "box": {
          "id": "masterline",
          "maxclass": "newobj",
          "patching_rect": [
            950,
            1080,
            180,
            22
          ],
          "text": "line~ 0."
        }
      },
      {
        "box": {
          "id": "bank",
          "maxclass": "newobj",
          "patching_rect": [
            30,
            920,
            210,
            22
          ],
          "varname": "bank",
          "text": "polybuffer~ third_#0"
        }
      },
      {
        "box": {
          "id": "outL",
          "maxclass": "newobj",
          "patching_rect": [
            380,
            1200,
            70,
            22
          ],
          "text": "*~",
          "varname": "output_left"
        }
      },
      {
        "box": {
          "id": "outR",
          "maxclass": "newobj",
          "patching_rect": [
            650,
            1200,
            70,
            22
          ],
          "text": "*~",
          "varname": "output_right"
        }
      },
      {
        "box": {
          "id": "dsp",
          "maxclass": "ezdac~",
          "patching_rect": [
            740,
            385,
            45,
            45
          ],
          "presentation": 1,
          "presentation_rect": [
            975,
            294,
            32,
            32
          ]
        }
      },
      {
        "box": {
          "id": "dsp_label",
          "maxclass": "comment",
          "patching_rect": [
            740,
            360,
            70,
            22
          ],
          "text": "Audio",
          "presentation": 1,
          "presentation_rect": [
            905,
            300,
            60,
            24
          ]
        }
      },
      {
        "box": {
          "id": "init",
          "maxclass": "newobj",
          "patching_rect": [
            30,
            860,
            90,
            22
          ],
          "text": "loadbang"
        }
      },
      {
        "box": {
          "id": "init0",
          "maxclass": "message",
          "patching_rect": [
            150,
            860,
            40,
            22
          ],
          "text": "0"
        }
      },
      {
        "box": {
          "id": "loop_note",
          "maxclass": "comment",
          "patching_rect": [
            25,
            600,
            790,
            22
          ],
          "text": "All audio shares one timeline. Position changes gains; STOP fades to silence.",
          "presentation": 0,
          "presentation_rect": [
            25,
            875,
            790,
            24
          ]
        }
      },
      {
        "box": {
          "id": "device_label_a",
          "maxclass": "comment",
          "patching_rect": [
            25,
            270,
            360,
            24
          ],
          "text": "Participant A EEG Receiver",
          "presentation": 0,
          "presentation_rect": [
            25,
            390,
            360,
            24
          ]
        }
      },
      {
        "box": {
          "id": "device_a",
          "maxclass": "comment",
          "patching_rect": [
            25,
            297,
            350,
            24
          ],
          "text": "Not assigned",
          "presentation": 0,
          "presentation_rect": [
            25,
            450,
            350,
            24
          ],
          "ignoreclick": 1
        }
      },
      {
        "box": {
          "id": "set_device_a",
          "maxclass": "newobj",
          "patching_rect": [
            1200,
            1268,
            180,
            22
          ],
          "text": "prepend set"
        }
      },
      {
        "box": {
          "id": "connection_a",
          "maxclass": "comment",
          "patching_rect": [
            25,
            327,
            350,
            24
          ],
          "text": "Waiting for receiver",
          "presentation": 1,
          "presentation_rect": [
            25,
            212,
            490,
            34
          ],
          "ignoreclick": 1
        }
      },
      {
        "box": {
          "id": "set_connection_a",
          "maxclass": "newobj",
          "patching_rect": [
            1200,
            1276,
            180,
            22
          ],
          "text": "prepend set"
        }
      },
      {
        "box": {
          "id": "device_label_b",
          "maxclass": "comment",
          "patching_rect": [
            455,
            270,
            360,
            24
          ],
          "text": "Participant B EEG Receiver",
          "presentation": 0,
          "presentation_rect": [
            455,
            390,
            360,
            24
          ]
        }
      },
      {
        "box": {
          "id": "device_b",
          "maxclass": "comment",
          "patching_rect": [
            455,
            297,
            350,
            24
          ],
          "text": "Not assigned",
          "presentation": 0,
          "presentation_rect": [
            455,
            450,
            350,
            24
          ],
          "ignoreclick": 1
        }
      },
      {
        "box": {
          "id": "set_device_b",
          "maxclass": "newobj",
          "patching_rect": [
            1200,
            1288,
            180,
            22
          ],
          "text": "prepend set"
        }
      },
      {
        "box": {
          "id": "connection_b",
          "maxclass": "comment",
          "patching_rect": [
            455,
            327,
            350,
            24
          ],
          "text": "Waiting for receiver",
          "presentation": 1,
          "presentation_rect": [
            545,
            212,
            500,
            34
          ],
          "ignoreclick": 1
        }
      },
      {
        "box": {
          "id": "set_connection_b",
          "maxclass": "newobj",
          "patching_rect": [
            1200,
            1296,
            180,
            22
          ],
          "text": "prepend set"
        }
      },
      {
        "box": {
          "id": "record_label",
          "maxclass": "comment",
          "patching_rect": [
            25,
            765,
            400,
            24
          ],
          "text": "Manual Input",
          "presentation": 1,
          "presentation_rect": [
            25,
            520,
            145,
            24
          ]
        }
      },
      {
        "box": {
          "id": "record_note",
          "maxclass": "comment",
          "patching_rect": [
            25,
            795,
            780,
            24
          ],
          "text": "Input 1 / mono / 45 s maximum. Recording replaces the selected A.wav or B.wav.",
          "presentation": 0,
          "presentation_rect": [
            25,
            945,
            780,
            24
          ]
        }
      },
      {
        "box": {
          "id": "record_a",
          "maxclass": "textbutton",
          "patching_rect": [
            25,
            830,
            120,
            26
          ],
          "text": "Record A",
          "presentation": 1,
          "presentation_rect": [
            180,
            518,
            105,
            28
          ],
          "mode": 0,
          "texton": "Record A",
          "numoutlets": 3,
          "outlettype": [
            "bang",
            "",
            "int"
          ],
          "parameter_enable": 0,
          "active": 1,
          "ignoreclick": 0,
          "outputmode": 0,
          "numinlets": 1
        }
      },
      {
        "box": {
          "id": "record_a_trigger",
          "maxclass": "newobj",
          "patching_rect": [
            25,
            1330,
            50,
            22
          ],
          "text": "t b"
        }
      },
      {
        "box": {
          "id": "record_a_msg",
          "maxclass": "message",
          "patching_rect": [
            25,
            1360,
            120,
            24
          ],
          "text": "record A"
        }
      },
      {
        "box": {
          "id": "record_b",
          "maxclass": "textbutton",
          "patching_rect": [
            160,
            830,
            120,
            26
          ],
          "text": "Record B",
          "presentation": 1,
          "presentation_rect": [
            300,
            518,
            105,
            28
          ],
          "mode": 0,
          "texton": "Record B",
          "numoutlets": 3,
          "outlettype": [
            "bang",
            "",
            "int"
          ],
          "parameter_enable": 0,
          "active": 1,
          "ignoreclick": 0,
          "outputmode": 0,
          "numinlets": 1
        }
      },
      {
        "box": {
          "id": "record_b_trigger",
          "maxclass": "newobj",
          "patching_rect": [
            160,
            1330,
            50,
            22
          ],
          "text": "t b"
        }
      },
      {
        "box": {
          "id": "record_b_msg",
          "maxclass": "message",
          "patching_rect": [
            160,
            1360,
            120,
            24
          ],
          "text": "record B"
        }
      },
      {
        "box": {
          "id": "record_stop",
          "maxclass": "textbutton",
          "patching_rect": [
            295,
            830,
            170,
            26
          ],
          "text": "Stop Recording",
          "presentation": 1,
          "presentation_rect": [
            420,
            518,
            155,
            28
          ],
          "mode": 0,
          "texton": "Stop Recording",
          "numoutlets": 3,
          "outlettype": [
            "bang",
            "",
            "int"
          ],
          "parameter_enable": 0,
          "active": 1,
          "ignoreclick": 0,
          "outputmode": 0,
          "numinlets": 1
        }
      },
      {
        "box": {
          "id": "record_stop_trigger",
          "maxclass": "newobj",
          "patching_rect": [
            295,
            1330,
            50,
            22
          ],
          "text": "t b"
        }
      },
      {
        "box": {
          "id": "record_stop_msg",
          "maxclass": "message",
          "patching_rect": [
            295,
            1360,
            120,
            24
          ],
          "text": "stoprecord"
        }
      },
      {
        "box": {
          "id": "recording",
          "maxclass": "comment",
          "patching_rect": [
            25,
            868,
            780,
            48
          ],
          "text": "Ready. Select the microphone in Max Audio Status.",
          "presentation": 1,
          "presentation_rect": [
            25,
            558,
            1020,
            34
          ]
        }
      },
      {
        "box": {
          "id": "set_recording",
          "maxclass": "newobj",
          "patching_rect": [
            1200,
            1348,
            180,
            22
          ],
          "text": "prepend set"
        }
      },
      {
        "box": {
          "id": "input_meter_label",
          "maxclass": "comment",
          "patching_rect": [
            585,
            830,
            100,
            24
          ],
          "text": "Mic Input",
          "presentation": 1,
          "presentation_rect": [
            650,
            520,
            80,
            24
          ]
        }
      },
      {
        "box": {
          "id": "input_meter",
          "maxclass": "meter~",
          "patching_rect": [
            690,
            830,
            115,
            24
          ],
          "presentation": 1,
          "presentation_rect": [
            740,
            520,
            160,
            24
          ]
        }
      },
      {
        "box": {
          "id": "session",
          "maxclass": "newobj",
          "patching_rect": [
            950,
            1320,
            170,
            22
          ],
          "text": "js session.js"
        }
      },
      {
        "box": {
          "id": "record_route",
          "maxclass": "newobj",
          "patching_rect": [
            950,
            1360,
            330,
            22
          ],
          "text": "route prompt recording dsp backend recordpath prompt_a mode countdown progress automatic performance",
          "numoutlets": 12
        }
      },
      {
        "box": {
          "id": "mic",
          "maxclass": "newobj",
          "patching_rect": [
            25,
            1420,
            110,
            22
          ],
          "text": "adc~ 1"
        }
      },
      {
        "box": {
          "id": "recorder_a",
          "maxclass": "newobj",
          "patching_rect": [
            250,
            1420,
            140,
            22
          ],
          "text": "sfrecord~ 1"
        }
      },
      {
        "box": {
          "id": "recorder_b",
          "maxclass": "newobj",
          "patching_rect": [
            500,
            1420,
            140,
            22
          ],
          "text": "sfrecord~ 1"
        }
      },
      {
        "box": {
          "id": "receivers",
          "maxclass": "newobj",
          "patching_rect": [
            1150,
            1550,
            180,
            24
          ],
          "text": "js receivers.js"
        }
      },
      {
        "box": {
          "id": "control_send",
          "maxclass": "newobj",
          "patching_rect": [
            1150,
            1660,
            245,
            24
          ],
          "text": "udpsend 127.0.0.1 9001"
        }
      },
      {
        "box": {
          "id": "receiver_menu_a",
          "maxclass": "umenu",
          "patching_rect": [
            25,
            297,
            350,
            26
          ],
          "items": [
            "Not assigned"
          ],
          "menumode": 0,
          "arrow": 1,
          "allowdrag": 0,
          "autopopulate": 0,
          "numinlets": 1,
          "numoutlets": 3,
          "outlettype": [
            "int",
            "",
            ""
          ],
          "annotation": "Select Participant A receiver. Python confirms the assignment.",
          "presentation": 1,
          "presentation_rect": [
            25,
            178,
            490,
            26
          ]
        }
      },
      {
        "box": {
          "id": "receiver_choice_a",
          "maxclass": "newobj",
          "patching_rect": [
            1150,
            1590,
            190,
            24
          ],
          "text": "prepend choosea"
        }
      },
      {
        "box": {
          "id": "receiver_ack_a",
          "maxclass": "newobj",
          "patching_rect": [
            1150,
            1510,
            190,
            24
          ],
          "text": "prepend assigneda"
        }
      },
      {
        "box": {
          "id": "receiver_menu_b",
          "maxclass": "umenu",
          "patching_rect": [
            455,
            297,
            350,
            26
          ],
          "items": [
            "Not assigned"
          ],
          "menumode": 0,
          "arrow": 1,
          "allowdrag": 0,
          "autopopulate": 0,
          "numinlets": 1,
          "numoutlets": 3,
          "outlettype": [
            "int",
            "",
            ""
          ],
          "annotation": "Select Participant B receiver. Python confirms the assignment.",
          "presentation": 1,
          "presentation_rect": [
            545,
            178,
            500,
            26
          ]
        }
      },
      {
        "box": {
          "id": "receiver_choice_b",
          "maxclass": "newobj",
          "patching_rect": [
            1360,
            1590,
            190,
            24
          ],
          "text": "prepend chooseb"
        }
      },
      {
        "box": {
          "id": "receiver_ack_b",
          "maxclass": "newobj",
          "patching_rect": [
            1360,
            1510,
            190,
            24
          ],
          "text": "prepend assignedb"
        }
      },
      {
        "box": {
          "id": "device_list_pre",
          "maxclass": "newobj",
          "patching_rect": [
            1150,
            1470,
            190,
            24
          ],
          "text": "prepend devices"
        }
      },
      {
        "box": {
          "id": "control_status_pre",
          "maxclass": "newobj",
          "patching_rect": [
            1360,
            1470,
            210,
            24
          ],
          "text": "prepend controlstatus"
        }
      },
      {
        "box": {
          "id": "refresh_receivers",
          "maxclass": "textbutton",
          "patching_rect": [
            835,
            297,
            205,
            27
          ],
          "texton": "Refresh Receivers",
          "mode": 0,
          "numinlets": 1,
          "numoutlets": 3,
          "text": "Refresh Receivers",
          "presentation": 1,
          "presentation_rect": [
            25,
            254,
            180,
            28
          ],
          "active": 1,
          "ignoreclick": 0,
          "outputmode": 0,
          "outlettype": [
            "bang",
            "",
            "int"
          ]
        }
      },
      {
        "box": {
          "id": "refresh_trigger",
          "maxclass": "newobj",
          "patching_rect": [
            1470,
            1550,
            50,
            24
          ],
          "text": "t b"
        }
      },
      {
        "box": {
          "id": "refresh_command",
          "maxclass": "message",
          "patching_rect": [
            1470,
            1590,
            85,
            24
          ],
          "text": "refresh"
        }
      },
      {
        "box": {
          "id": "receiver_feedback",
          "maxclass": "comment",
          "patching_rect": [
            835,
            330,
            210,
            65
          ],
          "text": "Click Start System, then Refresh Receivers.",
          "presentation": 1,
          "presentation_rect": [
            400,
            254,
            645,
            34
          ]
        }
      },
      {
        "box": {
          "id": "system_button",
          "maxclass": "textbutton",
          "patching_rect": [
            900,
            1740,
            150,
            28
          ],
          "text": "Start System",
          "presentation": 1,
          "presentation_rect": [
            220,
            254,
            160,
            28
          ],
          "mode": 0,
          "numoutlets": 3,
          "outlettype": [
            "bang",
            "",
            "int"
          ],
          "texton": "Start System",
          "active": 1,
          "ignoreclick": 0,
          "outputmode": 0,
          "numinlets": 1
        }
      },
      {
        "box": {
          "id": "system_trigger",
          "maxclass": "newobj",
          "patching_rect": [
            900,
            1780,
            35,
            22
          ],
          "text": "t b"
        }
      },
      {
        "box": {
          "id": "system_msg",
          "maxclass": "message",
          "patching_rect": [
            900,
            1810,
            70,
            22
          ],
          "text": "system"
        }
      },
      {
        "box": {
          "id": "generate_prompt",
          "maxclass": "textbutton",
          "patching_rect": [
            900,
            1850,
            190,
            28
          ],
          "text": "Generate Prompt",
          "presentation": 1,
          "presentation_rect": [
            910,
            603,
            135,
            28
          ],
          "mode": 0,
          "numoutlets": 3,
          "outlettype": [
            "bang",
            "",
            "int"
          ],
          "texton": "Generate B Prompt",
          "active": 1,
          "ignoreclick": 0,
          "outputmode": 0,
          "numinlets": 1
        }
      },
      {
        "box": {
          "id": "generate_prompt_trigger",
          "maxclass": "newobj",
          "patching_rect": [
            900,
            1880,
            35,
            22
          ],
          "text": "t b"
        }
      },
      {
        "box": {
          "id": "generate_prompt_msg",
          "maxclass": "message",
          "patching_rect": [
            950,
            1880,
            120,
            22
          ],
          "text": "generate prompt"
        }
      },
      {
        "box": {
          "id": "generate_audio",
          "maxclass": "textbutton",
          "patching_rect": [
            900,
            1940,
            190,
            28
          ],
          "text": "Generate Audio",
          "presentation": 1,
          "presentation_rect": [
            25,
            735,
            170,
            28
          ],
          "mode": 0,
          "numoutlets": 3,
          "outlettype": [
            "bang",
            "",
            "int"
          ],
          "texton": "Generate Audio",
          "active": 1,
          "ignoreclick": 0,
          "outputmode": 0,
          "numinlets": 1
        }
      },
      {
        "box": {
          "id": "generate_audio_trigger",
          "maxclass": "newobj",
          "patching_rect": [
            900,
            1970,
            35,
            22
          ],
          "text": "t b"
        }
      },
      {
        "box": {
          "id": "generate_audio_msg",
          "maxclass": "message",
          "patching_rect": [
            950,
            1970,
            120,
            22
          ],
          "text": "generate audio"
        }
      },
      {
        "box": {
          "id": "backend_status",
          "maxclass": "comment",
          "patching_rect": [
            900,
            2060,
            350,
            65
          ],
          "text": "Local controller status.",
          "presentation": 0,
          "presentation_rect": [
            215,
            732,
            830,
            48
          ]
        }
      },
      {
        "box": {
          "id": "set_backend",
          "maxclass": "newobj",
          "patching_rect": [
            900,
            2140,
            90,
            22
          ],
          "text": "prepend set"
        }
      },
      {
        "box": {
          "id": "session_send",
          "maxclass": "newobj",
          "patching_rect": [
            900,
            2170,
            190,
            22
          ],
          "text": "udpsend 127.0.0.1 9002"
        }
      },
      {
        "box": {
          "id": "system_launch",
          "maxclass": "message",
          "patching_rect": [
            900,
            2200,
            220,
            22
          ],
          "text": "; max launchbrowser $1"
        }
      },
      {
        "box": {
          "id": "session_backendstatus",
          "maxclass": "newobj",
          "patching_rect": [
            1150,
            1740,
            155,
            22
          ],
          "text": "prepend backendstatus"
        }
      },
      {
        "box": {
          "id": "session_backendprompt",
          "maxclass": "newobj",
          "patching_rect": [
            1150,
            1775,
            155,
            22
          ],
          "text": "prepend backendprompt"
        }
      },
      {
        "box": {
          "id": "session_complete",
          "maxclass": "newobj",
          "patching_rect": [
            1150,
            1810,
            155,
            22
          ],
          "text": "prepend complete"
        }
      },
      {
        "box": {
          "id": "record_path",
          "maxclass": "comment",
          "text": "Recording destination: project/audio/input/A.wav or B.wav",
          "patching_rect": [
            900,
            2240,
            600,
            24
          ],
          "presentation": 0,
          "presentation_rect": [
            25,
            1365,
            1020,
            24
          ]
        }
      },
      {
        "box": {
          "id": "set_record_path",
          "maxclass": "newobj",
          "text": "prepend set",
          "patching_rect": [
            900,
            2270,
            100,
            22
          ]
        }
      },
      {
        "box": {
          "id": "shared_clock",
          "maxclass": "newobj",
          "text": "phasor~ 0.",
          "patching_rect": [
            25,
            2250,
            100,
            22
          ],
          "varname": "shared_clock"
        }
      },
      {
        "box": {
          "id": "shared_time",
          "maxclass": "newobj",
          "text": "*~ 1.",
          "patching_rect": [
            25,
            2290,
            100,
            22
          ],
          "varname": "shared_time"
        }
      },
      {
        "box": {
          "id": "sync_players",
          "maxclass": "newobj",
          "text": "poly~ synchronized_voice 12",
          "patching_rect": [
            240,
            2290,
            225,
            22
          ],
          "varname": "sync_players"
        }
      },
      {
        "box": {
          "id": "session_backendprompta",
          "maxclass": "newobj",
          "patching_rect": [
            300,
            2520,
            170,
            22
          ],
          "text": "prepend backendprompta"
        }
      },
      {
        "box": {
          "id": "api_prompt_a_label",
          "maxclass": "comment",
          "patching_rect": [
            25,
            2560,
            490,
            24
          ],
          "text": "A Prompt",
          "presentation": 1,
          "presentation_rect": [
            25,
            605,
            250,
            24
          ]
        }
      },
      {
        "box": {
          "id": "api_prompt_a",
          "maxclass": "textedit",
          "patching_rect": [
            25,
            2600,
            490,
            100
          ],
          "varname": "api_prompt_a",
          "outputmode": 1,
          "keymode": 0,
          "readonly": 0,
          "numinlets": 1,
          "numoutlets": 4,
          "text": "",
          "presentation": 1,
          "presentation_rect": [
            25,
            638,
            490,
            80
          ]
        }
      },
      {
        "box": {
          "id": "api_prompt_b_label",
          "maxclass": "comment",
          "patching_rect": [
            535,
            2560,
            490,
            24
          ],
          "text": "B Prompt",
          "presentation": 1,
          "presentation_rect": [
            545,
            605,
            250,
            24
          ]
        }
      },
      {
        "box": {
          "id": "api_prompt_b",
          "maxclass": "textedit",
          "patching_rect": [
            535,
            2600,
            490,
            100
          ],
          "varname": "api_prompt_b",
          "outputmode": 1,
          "keymode": 0,
          "readonly": 0,
          "numinlets": 1,
          "numoutlets": 4,
          "text": "",
          "presentation": 1,
          "presentation_rect": [
            545,
            638,
            500,
            80
          ]
        }
      },
      {
        "box": {
          "id": "generate_prompt_a",
          "maxclass": "textbutton",
          "patching_rect": [
            25,
            2820,
            195,
            28
          ],
          "text": "Generate Prompt",
          "presentation": 1,
          "presentation_rect": [
            380,
            603,
            135,
            28
          ],
          "mode": 0,
          "numoutlets": 3,
          "outlettype": [
            "bang",
            "",
            "int"
          ],
          "texton": "Generate A Prompt",
          "active": 1,
          "ignoreclick": 0,
          "outputmode": 0,
          "numinlets": 1
        }
      },
      {
        "box": {
          "id": "generate_prompt_a_trigger",
          "maxclass": "newobj",
          "patching_rect": [
            25,
            2860,
            35,
            22
          ],
          "text": "t b"
        }
      },
      {
        "box": {
          "id": "generate_prompt_a_msg",
          "maxclass": "message",
          "patching_rect": [
            100,
            2860,
            160,
            22
          ],
          "text": "generate prompta"
        }
      },
      {
        "box": {
          "id": "auto_bank",
          "maxclass": "newobj",
          "text": "polybuffer~ third_#0_auto",
          "patching_rect": [
            25,
            6328,
            350,
            22
          ]
        }
      },
      {
        "box": {
          "id": "auto_players",
          "maxclass": "newobj",
          "text": "poly~ synchronized_voice 12",
          "patching_rect": [
            25,
            6352,
            350,
            22
          ]
        }
      },
      {
        "box": {
          "id": "auto_time",
          "maxclass": "newobj",
          "text": "*~ 10000.",
          "patching_rect": [
            25,
            6376,
            350,
            22
          ]
        }
      },
      {
        "box": {
          "id": "auto_automode",
          "maxclass": "newobj",
          "text": "prepend automode",
          "patching_rect": [
            25,
            6400,
            350,
            22
          ]
        }
      },
      {
        "box": {
          "id": "auto_countdown",
          "maxclass": "newobj",
          "text": "prepend countdown",
          "patching_rect": [
            25,
            6424,
            350,
            22
          ]
        }
      },
      {
        "box": {
          "id": "auto_progress",
          "maxclass": "newobj",
          "text": "prepend progress",
          "patching_rect": [
            25,
            6448,
            350,
            22
          ]
        }
      },
      {
        "box": {
          "id": "auto_autoplay",
          "maxclass": "newobj",
          "text": "prepend autoplay",
          "patching_rect": [
            25,
            6472,
            350,
            22
          ]
        }
      },
      {
        "box": {
          "id": "auto_autoposition",
          "maxclass": "newobj",
          "text": "prepend autoposition",
          "patching_rect": [
            25,
            6496,
            350,
            22
          ]
        }
      },
      {
        "box": {
          "id": "auto_autoenabled",
          "maxclass": "newobj",
          "text": "prepend autoenabled",
          "patching_rect": [
            25,
            6520,
            350,
            22
          ]
        }
      },
      {
        "box": {
          "id": "auto_mode_label",
          "maxclass": "comment",
          "text": "Mode: Waiting",
          "patching_rect": [
            25,
            6544,
            350,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            300,
            20,
            220,
            24
          ]
        }
      },
      {
        "box": {
          "id": "set_auto_mode",
          "maxclass": "newobj",
          "text": "prepend set",
          "patching_rect": [
            25,
            6568,
            350,
            22
          ]
        }
      },
      {
        "box": {
          "id": "auto_countdown_label",
          "maxclass": "comment",
          "text": "Countdown: 0 s",
          "patching_rect": [
            25,
            6592,
            350,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            530,
            20,
            200,
            24
          ]
        }
      },
      {
        "box": {
          "id": "set_auto_countdown",
          "maxclass": "newobj",
          "text": "prepend set",
          "patching_rect": [
            25,
            6616,
            350,
            22
          ]
        }
      },
      {
        "box": {
          "id": "auto_progress_label",
          "maxclass": "comment",
          "text": "Waiting for stable EEG.",
          "patching_rect": [
            25,
            6640,
            350,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            25,
            58,
            1020,
            42
          ]
        }
      },
      {
        "box": {
          "id": "set_auto_progress",
          "maxclass": "newobj",
          "text": "prepend set",
          "patching_rect": [
            25,
            6664,
            350,
            22
          ]
        }
      },
      {
        "box": {
          "id": "auto_toggle_label",
          "maxclass": "comment",
          "text": "Automatic",
          "patching_rect": [
            25,
            6688,
            350,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            735,
            20,
            80,
            24
          ]
        }
      },
      {
        "box": {
          "id": "auto_toggle",
          "maxclass": "toggle",
          "patching_rect": [
            700,
            2600,
            24,
            24
          ],
          "presentation": 1,
          "presentation_rect": [
            817,
            20,
            22,
            22
          ],
          "numinlets": 1,
          "numoutlets": 1
        }
      },
      {
        "box": {
          "id": "auto_toggle_pre",
          "maxclass": "newobj",
          "text": "prepend setautomatic",
          "patching_rect": [
            25,
            6736,
            350,
            22
          ]
        }
      },
      {
        "box": {
          "id": "set_auto_enabled",
          "maxclass": "newobj",
          "text": "prepend set",
          "patching_rect": [
            25,
            6760,
            350,
            22
          ]
        }
      },
      {
        "box": {
          "id": "new_session",
          "maxclass": "textbutton",
          "text": "Reset / New Session",
          "patching_rect": [
            25,
            6784,
            350,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            855,
            18,
            190,
            28
          ],
          "mode": 0,
          "numinlets": 1,
          "numoutlets": 3
        }
      },
      {
        "box": {
          "id": "new_session_trigger",
          "maxclass": "newobj",
          "text": "t b",
          "patching_rect": [
            25,
            6808,
            350,
            22
          ]
        }
      },
      {
        "box": {
          "id": "new_session_msg",
          "maxclass": "message",
          "text": "new_session",
          "patching_rect": [
            25,
            6832,
            350,
            22
          ]
        }
      },
      {
        "box": {
          "id": "performance_recorder",
          "maxclass": "newobj",
          "text": "sfrecord~ 2",
          "patching_rect": [
            25,
            13225,
            350,
            22
          ],
          "varname": "performance_recorder",
          "numinlets": 2,
          "numoutlets": 2
        }
      },
      {
        "box": {
          "id": "performance_record_label",
          "maxclass": "comment",
          "text": "Performance Recording",
          "patching_rect": [
            25,
            13250,
            350,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            25,
            420,
            190,
            28
          ]
        }
      },
      {
        "box": {
          "id": "performance_record",
          "maxclass": "textbutton",
          "text": "Record Performance",
          "patching_rect": [
            25,
            13275,
            350,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            225,
            420,
            205,
            28
          ],
          "mode": 0,
          "numinlets": 1,
          "numoutlets": 3
        }
      },
      {
        "box": {
          "id": "performance_record_trigger",
          "maxclass": "newobj",
          "text": "t b",
          "patching_rect": [
            25,
            13300,
            350,
            22
          ]
        }
      },
      {
        "box": {
          "id": "performance_record_msg",
          "maxclass": "message",
          "text": "record_performance",
          "patching_rect": [
            25,
            13325,
            350,
            22
          ]
        }
      },
      {
        "box": {
          "id": "performance_stop",
          "maxclass": "textbutton",
          "text": "Stop Performance Recording",
          "patching_rect": [
            25,
            13350,
            350,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            445,
            420,
            265,
            28
          ],
          "mode": 0,
          "numinlets": 1,
          "numoutlets": 3
        }
      },
      {
        "box": {
          "id": "performance_stop_trigger",
          "maxclass": "newobj",
          "text": "t b",
          "patching_rect": [
            25,
            13375,
            350,
            22
          ]
        }
      },
      {
        "box": {
          "id": "performance_stop_msg",
          "maxclass": "message",
          "text": "stop_performance",
          "patching_rect": [
            25,
            13400,
            350,
            22
          ]
        }
      },
      {
        "box": {
          "id": "performance_status",
          "maxclass": "comment",
          "text": "Ready. Records the final stereo Max output.",
          "patching_rect": [
            25,
            13425,
            350,
            22
          ],
          "presentation": 1,
          "presentation_rect": [
            25,
            458,
            1020,
            42
          ]
        }
      },
      {
        "box": {
          "id": "set_performance_status",
          "maxclass": "newobj",
          "text": "prepend set",
          "patching_rect": [
            25,
            13450,
            350,
            22
          ]
        }
      }
    ],
    "lines": [
      {
        "patchline": {
          "source": [
            "udp",
            0
          ],
          "destination": [
            "oscroute",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "oscroute",
            0
          ],
          "destination": [
            "oscpos",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "oscpos",
            0
          ],
          "destination": [
            "nav",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "oscroute",
            1
          ],
          "destination": [
            "a_attention",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "oscroute",
            2
          ],
          "destination": [
            "a_meditation",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "oscroute",
            3
          ],
          "destination": [
            "a_signal",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "oscroute",
            4
          ],
          "destination": [
            "b_attention",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "oscroute",
            5
          ],
          "destination": [
            "b_meditation",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "oscroute",
            6
          ],
          "destination": [
            "b_signal",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "slider",
            0
          ],
          "destination": [
            "manual",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "manual",
            0
          ],
          "destination": [
            "nav",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "slider_set",
            0
          ],
          "destination": [
            "slider",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "nav",
            4
          ],
          "destination": [
            "tele",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "tele",
            1
          ],
          "destination": [
            "continuous",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "tele",
            2
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
            "tele",
            3
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
            "tele",
            4
          ],
          "destination": [
            "crossfade",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "tele",
            6
          ],
          "destination": [
            "count",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "tele",
            0
          ],
          "destination": [
            "position",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "tele",
            0
          ],
          "destination": [
            "slider_set",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "set_pair",
            0
          ],
          "destination": [
            "pair",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "tele",
            5
          ],
          "destination": [
            "set_pair",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "set_folder",
            0
          ],
          "destination": [
            "folder",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "tele",
            7
          ],
          "destination": [
            "set_folder",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "set_status",
            0
          ],
          "destination": [
            "status",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "tele",
            8
          ],
          "destination": [
            "set_status",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "set_audio",
            0
          ],
          "destination": [
            "audio",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "tele",
            9
          ],
          "destination": [
            "set_audio",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "start",
            0
          ],
          "destination": [
            "start_trigger",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "start_trigger",
            0
          ],
          "destination": [
            "start_msg",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "start_msg",
            0
          ],
          "destination": [
            "nav",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "stop",
            0
          ],
          "destination": [
            "stop_trigger",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "stop_trigger",
            0
          ],
          "destination": [
            "stop_msg",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "stop_msg",
            0
          ],
          "destination": [
            "nav",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "reload",
            0
          ],
          "destination": [
            "reload_trigger",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "reload_trigger",
            0
          ],
          "destination": [
            "reload_msg",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "reload_msg",
            0
          ],
          "destination": [
            "nav",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "choose",
            0
          ],
          "destination": [
            "choose_trigger",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "choose_trigger",
            0
          ],
          "destination": [
            "dialog",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "dialog",
            0
          ],
          "destination": [
            "folder_pre",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "folder_pre",
            0
          ],
          "destination": [
            "nav",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "tele",
            11
          ],
          "destination": [
            "master",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "master",
            0
          ],
          "destination": [
            "masterclip",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "masterclip",
            0
          ],
          "destination": [
            "masterpack",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "masterpack",
            0
          ],
          "destination": [
            "masterline",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "nav",
            5
          ],
          "destination": [
            "bank",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "masterline",
            0
          ],
          "destination": [
            "outL",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "masterline",
            0
          ],
          "destination": [
            "outR",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "outL",
            0
          ],
          "destination": [
            "dsp",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "outR",
            0
          ],
          "destination": [
            "dsp",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "tele",
            10
          ],
          "destination": [
            "dsp",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "init",
            0
          ],
          "destination": [
            "init0",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "init0",
            0
          ],
          "destination": [
            "dsp",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "set_device_a",
            0
          ],
          "destination": [
            "device_a",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "set_connection_a",
            0
          ],
          "destination": [
            "connection_a",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "oscroute",
            7
          ],
          "destination": [
            "set_device_a",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "oscroute",
            9
          ],
          "destination": [
            "set_connection_a",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "set_device_b",
            0
          ],
          "destination": [
            "device_b",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "set_connection_b",
            0
          ],
          "destination": [
            "connection_b",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "oscroute",
            8
          ],
          "destination": [
            "set_device_b",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "oscroute",
            10
          ],
          "destination": [
            "set_connection_b",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "record_a",
            0
          ],
          "destination": [
            "record_a_trigger",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "record_a_trigger",
            0
          ],
          "destination": [
            "record_a_msg",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "record_a_msg",
            0
          ],
          "destination": [
            "session",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "record_b",
            0
          ],
          "destination": [
            "record_b_trigger",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "record_b_trigger",
            0
          ],
          "destination": [
            "record_b_msg",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "record_b_msg",
            0
          ],
          "destination": [
            "session",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "record_stop",
            0
          ],
          "destination": [
            "record_stop_trigger",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "record_stop_trigger",
            0
          ],
          "destination": [
            "record_stop_msg",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "record_stop_msg",
            0
          ],
          "destination": [
            "session",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "set_recording",
            0
          ],
          "destination": [
            "recording",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "session",
            2
          ],
          "destination": [
            "record_route",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "record_route",
            1
          ],
          "destination": [
            "set_recording",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "record_route",
            2
          ],
          "destination": [
            "dsp",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "session",
            3
          ],
          "destination": [
            "nav",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "folder_pre",
            0
          ],
          "destination": [
            "session",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "mic",
            0
          ],
          "destination": [
            "input_meter",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "mic",
            0
          ],
          "destination": [
            "recorder_a",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "session",
            0
          ],
          "destination": [
            "recorder_a",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "mic",
            0
          ],
          "destination": [
            "recorder_b",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "session",
            1
          ],
          "destination": [
            "recorder_b",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "receivers",
            2
          ],
          "destination": [
            "control_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "receiver_menu_a",
            0
          ],
          "destination": [
            "receiver_choice_a",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "receiver_choice_a",
            0
          ],
          "destination": [
            "receivers",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "receivers",
            0
          ],
          "destination": [
            "receiver_menu_a",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "oscroute",
            7
          ],
          "destination": [
            "receiver_ack_a",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "receiver_ack_a",
            0
          ],
          "destination": [
            "receivers",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "receiver_menu_b",
            0
          ],
          "destination": [
            "receiver_choice_b",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "receiver_choice_b",
            0
          ],
          "destination": [
            "receivers",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "receivers",
            1
          ],
          "destination": [
            "receiver_menu_b",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "oscroute",
            8
          ],
          "destination": [
            "receiver_ack_b",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "receiver_ack_b",
            0
          ],
          "destination": [
            "receivers",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "oscroute",
            11
          ],
          "destination": [
            "device_list_pre",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "device_list_pre",
            0
          ],
          "destination": [
            "receivers",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "oscroute",
            12
          ],
          "destination": [
            "control_status_pre",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "control_status_pre",
            0
          ],
          "destination": [
            "receivers",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "refresh_receivers",
            0
          ],
          "destination": [
            "refresh_trigger",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "refresh_trigger",
            0
          ],
          "destination": [
            "refresh_command",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "refresh_command",
            0
          ],
          "destination": [
            "receivers",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "receivers",
            3
          ],
          "destination": [
            "receiver_feedback",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "system_button",
            0
          ],
          "destination": [
            "system_trigger",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "system_trigger",
            0
          ],
          "destination": [
            "system_msg",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "system_msg",
            0
          ],
          "destination": [
            "session",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "generate_prompt",
            0
          ],
          "destination": [
            "generate_prompt_trigger",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "generate_prompt_trigger",
            0
          ],
          "destination": [
            "generate_prompt_msg",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "generate_prompt_msg",
            0
          ],
          "destination": [
            "session",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "generate_audio",
            0
          ],
          "destination": [
            "generate_audio_trigger",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "generate_audio_trigger",
            0
          ],
          "destination": [
            "generate_audio_msg",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "generate_audio_msg",
            0
          ],
          "destination": [
            "session",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "record_route",
            3
          ],
          "destination": [
            "set_backend",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "set_backend",
            0
          ],
          "destination": [
            "backend_status",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "session",
            4
          ],
          "destination": [
            "session_send",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "session",
            5
          ],
          "destination": [
            "system_launch",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "oscroute",
            13
          ],
          "destination": [
            "session_backendstatus",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "session_backendstatus",
            0
          ],
          "destination": [
            "session",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "oscroute",
            14
          ],
          "destination": [
            "session_backendprompt",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "session_backendprompt",
            0
          ],
          "destination": [
            "session",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "oscroute",
            15
          ],
          "destination": [
            "session_complete",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "session_complete",
            0
          ],
          "destination": [
            "session",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "record_route",
            4
          ],
          "destination": [
            "set_record_path",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "set_record_path",
            0
          ],
          "destination": [
            "record_path",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "nav",
            0
          ],
          "destination": [
            "shared_clock",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "nav",
            1
          ],
          "destination": [
            "shared_time",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "nav",
            2
          ],
          "destination": [
            "shared_clock",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "shared_clock",
            0
          ],
          "destination": [
            "shared_time",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "shared_time",
            0
          ],
          "destination": [
            "sync_players",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "nav",
            3
          ],
          "destination": [
            "sync_players",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "sync_players",
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
            "sync_players",
            1
          ],
          "destination": [
            "outR",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "oscroute",
            16
          ],
          "destination": [
            "session_backendprompta",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "session_backendprompta",
            0
          ],
          "destination": [
            "session",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "generate_prompt_a",
            0
          ],
          "destination": [
            "generate_prompt_a_trigger",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "generate_prompt_a_trigger",
            0
          ],
          "destination": [
            "generate_prompt_a_msg",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "generate_prompt_a_msg",
            0
          ],
          "destination": [
            "session",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "nav",
            7
          ],
          "destination": [
            "auto_bank",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "nav",
            8
          ],
          "destination": [
            "auto_players",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "nav",
            9
          ],
          "destination": [
            "auto_time",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "shared_clock",
            0
          ],
          "destination": [
            "auto_time",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "auto_time",
            0
          ],
          "destination": [
            "auto_players",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "auto_players",
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
            "auto_players",
            1
          ],
          "destination": [
            "outR",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "oscroute",
            17
          ],
          "destination": [
            "auto_automode",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "auto_automode",
            0
          ],
          "destination": [
            "session",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "oscroute",
            18
          ],
          "destination": [
            "auto_countdown",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "auto_countdown",
            0
          ],
          "destination": [
            "session",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "oscroute",
            19
          ],
          "destination": [
            "auto_progress",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "auto_progress",
            0
          ],
          "destination": [
            "session",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "oscroute",
            20
          ],
          "destination": [
            "auto_autoplay",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "auto_autoplay",
            0
          ],
          "destination": [
            "session",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "oscroute",
            21
          ],
          "destination": [
            "auto_autoposition",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "auto_autoposition",
            0
          ],
          "destination": [
            "session",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "oscroute",
            22
          ],
          "destination": [
            "auto_autoenabled",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "auto_autoenabled",
            0
          ],
          "destination": [
            "session",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "record_route",
            6
          ],
          "destination": [
            "set_auto_mode",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "set_auto_mode",
            0
          ],
          "destination": [
            "auto_mode_label",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "record_route",
            7
          ],
          "destination": [
            "set_auto_countdown",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "set_auto_countdown",
            0
          ],
          "destination": [
            "auto_countdown_label",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "record_route",
            8
          ],
          "destination": [
            "set_auto_progress",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "set_auto_progress",
            0
          ],
          "destination": [
            "auto_progress_label",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "auto_toggle",
            0
          ],
          "destination": [
            "auto_toggle_pre",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "auto_toggle_pre",
            0
          ],
          "destination": [
            "session",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "record_route",
            9
          ],
          "destination": [
            "set_auto_enabled",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "set_auto_enabled",
            0
          ],
          "destination": [
            "auto_toggle",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "new_session",
            0
          ],
          "destination": [
            "new_session_trigger",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "new_session_trigger",
            0
          ],
          "destination": [
            "new_session_msg",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "new_session_msg",
            0
          ],
          "destination": [
            "session",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "outL",
            0
          ],
          "destination": [
            "performance_recorder",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "outR",
            0
          ],
          "destination": [
            "performance_recorder",
            1
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "performance_record",
            0
          ],
          "destination": [
            "performance_record_trigger",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "performance_record_trigger",
            0
          ],
          "destination": [
            "performance_record_msg",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "performance_record_msg",
            0
          ],
          "destination": [
            "session",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "performance_stop",
            0
          ],
          "destination": [
            "performance_stop_trigger",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "performance_stop_trigger",
            0
          ],
          "destination": [
            "performance_stop_msg",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "performance_stop_msg",
            0
          ],
          "destination": [
            "session",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "record_route",
            10
          ],
          "destination": [
            "set_performance_status",
            0
          ]
        }
      },
      {
        "patchline": {
          "source": [
            "set_performance_status",
            0
          ],
          "destination": [
            "performance_status",
            0
          ]
        }
      }
    ],
    "dependency_cache": [
      {
        "name": "navigation.js",
        "bootpath": ".",
        "type": "TEXT",
        "implicit": 1
      },
      {
        "name": "session.js",
        "bootpath": ".",
        "type": "TEXT",
        "implicit": 1
      },
      {
        "name": "receivers.js",
        "bootpath": ".",
        "type": "TEXT",
        "implicit": 1
      }
    ]
  }
}
