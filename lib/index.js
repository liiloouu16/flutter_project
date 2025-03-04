import express from 'express';

export const app = express();

const port = 3000;

app.listen(port, () => {
  console.log(`Mon serveur démarre sur le port ${port}`);
});