import argparse
import asyncio
import logging
import pickle

logging.basicConfig(level=logging.INFO)

@asyncio.coroutine
def handle_echo(reader, writer):
    data = yield from reader.read(100)
    message = data.decode()
    addr = writer.get_extra_info('peername')
    logging.info("Received {} from {}".format(message, addr))
    try:
        payload = pickle.loads(data)
        logging.info("Send: {}".format(payload))
    except pickle.UnpicklingError as e:
        logging.error("Could not unpickle data '{}'".format(data))
    writer.write(data)
    yield from writer.drain()

    logging.info("Close the client socket")
    writer.close()

def main(args):
    loop = asyncio.get_event_loop()
    coro = asyncio.start_server(handle_echo, args.server_addr,
                                args.server_port, loop=loop)
    server = loop.run_until_complete(coro)

    # Serve requests until Ctrl+C is pressed
    print('Serving on {}'.format(server.sockets[0].getsockname()))
    try:
        loop.run_forever()
    except KeyboardInterrupt:
        pass

    # Close the server
    server.close()
    loop.run_until_complete(server.wait_closed())
    loop.close()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description='Starts pickle to kairosDB server.')
    parser.add_argument('--server_addr', help='Server address',
                        default='127.0.0.1')
    parser.add_argument('--server_port', help='Server port', type=int,
                        default=8888)
    args = parser.parse_args()
    main(args)
