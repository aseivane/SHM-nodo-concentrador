FROM gcc:4.9
WORKDIR /app
COPY E-SIC /app/E-SIC
COPY entrypoint.sh .
RUN make -C E-SIC/client-server server
RUN mv E-SIC/client-server/server server
RUN rm -rf E-SIC
CMD ["./entrypoint.sh"]