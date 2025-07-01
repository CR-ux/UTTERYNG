'use strict';

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
      const message = answers.message;

      const spawn = require('child_process').spawn;
      const args = ['commit', '--author', `"${name} <${email}>"`, '-m', message];
      const git = spawn('git', args, { stdio: 'inherit', shell: true });

      git.on('exit', code => {
        if (code !== 0) {
          console.error(`\n❌ Git commit failed with code ${code}`);
        }
      });
    });
  }
};
