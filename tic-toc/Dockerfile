FROM gcc:4.9
WORKDIR /app
COPY E-SIC /app/E-SIC
RUN make -C E-SIC/client-server server
RUN mv E-SIC/client-server/server server
RUN rm -rf E-SIC
CMD ["./server"]