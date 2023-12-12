const std = @import("std");

pub fn main() !void {
    const testInput = @embedFile("real-input.txt");
    const lineWidth: usize = 142;

    var sum: i32 = 0;

    for (testInput, 0..) |character, index| {
        const isSymbol: bool = !std.ascii.isDigit(character) and character != '.' and character != '\n' and character != '\r';

        if (isSymbol) {
            const line: usize = index / lineWidth;
            const offset: usize = index % lineWidth;
            var neighbors = [_]usize{ index - 1, index + 1, (line - 1) * lineWidth + offset - 1, (line - 1) * lineWidth + offset, (line - 1) * lineWidth + offset + 1, (line + 1) * lineWidth + offset - 1, (line + 1) * lineWidth + offset, (line + 1) * lineWidth + offset + 1 };

            std.debug.print("index: {d}, symbol: {c}, value:{}\n", .{ index, character, character });

            var list = std.ArrayList(i32).init(std.heap.page_allocator);
            defer list.deinit();

            for (neighbors) |neighbor| {
                const char = testInput[neighbor];
                if (std.ascii.isDigit(char)) {
                    var startIndex: usize = neighbor;
                    var endIndex: usize = neighbor;

                    while (std.ascii.isDigit(testInput[startIndex - 1])) {
                        startIndex -= 1;
                        if (startIndex == 0) {
                            break;
                        }
                    }

                    while (std.ascii.isDigit(testInput[endIndex])) {
                        endIndex += 1;
                    }

                    const number = testInput[startIndex..endIndex];
                    const value = try std.fmt.parseInt(i32, number, 10);
                    if (!ContainsItem(i32, list.items, value)) {
                        sum += value;
                        try list.append(value);
                        std.debug.print("{s}\n", .{number});
                    }
                }
            }
        }
    }

    std.debug.print("sum: {d}\n", .{sum});
}

fn ContainsItem(comptime T: type, items: []const T, item: T) bool {
    for (items) |element| {
        if (element == item) {
            return true;
        }
    }
    return false;
}
