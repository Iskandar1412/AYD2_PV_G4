const express = require("express");
const cors = require("cors");

const app = express();

app.use(express.json());
app.use(cors({origin: '*'}));

// Rutas
app.use("/api/client", require("./routes/client.routes"));
app.use("/api/personal", require("./routes/personal.routes"))
app.use("/api/user", require("./routes/user.routes"))

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}.`);
});
