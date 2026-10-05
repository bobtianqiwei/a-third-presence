# thinkgear.py developed by Bob Tianqi Wei
"""Incremental ThinkGear framing and payload decoding."""
BANDS = ('delta', 'theta', 'low_alpha', 'high_alpha', 'low_beta',
         'high_beta', 'low_gamma', 'mid_gamma')


def decode(payload):
    result = {}
    i = 0
    while i < len(payload):
        extended = 0
        while i < len(payload) and payload[i] == 0x55:
            extended += 1
            i += 1
        if i >= len(payload):
            raise ValueError('Missing data code.')
        code = payload[i]
        i += 1
        length = 1
        if code >= 0x80:
            if i >= len(payload):
                raise ValueError('Missing data length.')
            length = payload[i]
            i += 1
        if i + length > len(payload):
            raise ValueError('Truncated data row.')
        value = payload[i:i + length]
        i += length
        if extended:
            continue
        names = {2: 'signal', 4: 'attention', 5: 'meditation', 0x16: 'blink'}
        if code in names:
            result[names[code]] = value[0]
        elif code == 0x80 and length == 2:
            result['raw'] = int.from_bytes(value, 'big', signed=True)
        elif code == 0x83 and length == 24:
            result.update({name: int.from_bytes(value[j:j + 3], 'big')
                           for name, j in zip(BANDS, range(0, 24, 3))})
    return result


class ThinkGearParser:
    def __init__(self):
        self.buffer = bytearray()
        self.checksum_errors = 0
        self.malformed_packets = 0

    def feed(self, data):
        self.buffer.extend(data)
        packets = []
        while True:
            start = self.buffer.find(b'\xaa\xaa')
            if start < 0:
                self.buffer[:] = b'\xaa' if self.buffer[-1:] == b'\xaa' else b''
                break
            del self.buffer[:start]
            if len(self.buffer) < 3:
                break
            length = self.buffer[2]
            if length > 169:
                del self.buffer[0]
                continue
            if len(self.buffer) < length + 4:
                break
            payload = bytes(self.buffer[3:3 + length])
            if self.buffer[3 + length] != (~sum(payload) & 255):
                self.checksum_errors += 1
                del self.buffer[0]
                continue
            del self.buffer[:length + 4]
            try:
                packets.append(decode(payload))
            except ValueError:
                self.malformed_packets += 1
        return packets
