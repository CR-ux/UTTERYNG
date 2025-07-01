'use strict';

const { execSync } = require('child_process');

const authors = {
  "Aria":        "aria@AI:RA.net",
  "RA":          "AIRA@aria.net",            // AI:RA
  "Clara":       "clara@notBorges.net",
  "me":          "noet.borges@rosepetal.com" // notBorges
};

const displayNames = {
  "Aria":        "Aria",
  "RA":          "AI:RA",
  "Clara":       "Clara",
  "me":          "notBorges"
};

module.exports = {
  prompter(cz, commit) {
    cz.prompt([
      {
        type: 'list',
        name: 'authorKey',
        message: '👤 Who is writing this commit?',
        choices: Object.keys(authors)
      },
      {
        type: 'input',
        name: 'message',
        message: '🖋 What happened?'
      }
    ]).then(answers => {
      const key = answers.authorKey;
      const name = displayNames[key];
      const email = authors[key];

      const rawMsg = answers.message.trim();
      const safeMsg = rawMsg.replace(/"/g, '\\"'); // escape quotes

      const commitMsg = `[${name}] ${safeMsg}`;
      const authorTag = `"${name} <${email}>"`;

      try {
        const command = `git commit --author=${authorTag} -m "${commitMsg}"`;
        execSync(command, { stdio: 'inherit' });
      } catch (err) {
        console.error(`\n❌ Git commit failed:\n${err.message}`);
      }
    });
  }
};
