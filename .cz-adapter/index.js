'use strict';

const fs = require('fs');
const path = require('path');
const { execSync, spawnSync } = require('child_process');

const authors = {
  "Aria":  "aria@AI:RA.net",
  "RA":    "AIRA@aria.net",            // AI:RA
  "Clara": "clara@notBorges.net",
  "me":    "noet.borges@rosepetal.com" // notBorges
};

const displayNames = {
  "Aria":  "Aria",
  "RA":    "AI:RA",
  "Clara": "Clara",
  "me":    "notBorges"
};

module.exports = {
  prompter(cz, commit) {
    const scrollDir = './Scroll';

    const scrollFiles = fs.existsSync(scrollDir)
      ? fs.readdirSync(scrollDir).filter(f => f.match(/\.(txt|md)$/))
      : [];

    const choices = scrollFiles.length
      ? [...scrollFiles.map(f => path.join(scrollDir, f)), '[Write new message in VSCode]']
      : ['[Write new message in VSCode]'];

    cz.prompt([
      {
        type: 'list',
        name: 'authorKey',
        message: '👤 Who is writing this commit?',
        choices: Object.keys(authors)
      },
      {
        type: 'list',
        name: 'messageSource',
        message: '📜 Choose a scroll or compose anew:',
        choices: choices
      }
    ]).then(async answers => {
      const key = answers.authorKey;
      const name = displayNames[key];
      const email = authors[key];
      let message = '';

      if (answers.messageSource === '[Write new message in VSCode]') {
        const tempPath = path.join(scrollDir, '__draft.md');
        fs.writeFileSync(tempPath, '# Write your commit message below.\n', 'utf8');

        spawnSync('code', ['--wait', tempPath], { stdio: 'inherit' });

        message = fs.readFileSync(tempPath, 'utf8')
          .split('\n')
          .filter(line => !line.startsWith('#'))
          .join('\n')
          .trim();

        fs.unlinkSync(tempPath); // clean up draft
      } else {
        message = fs.readFileSync(answers.messageSource, 'utf8').trim();
      }

      if (!message) {
        console.error('❌ Empty message. Commit aborted.');
        return;
      }

      const safeMsg = message.replace(/"/g, '\\"');
      const commitMsg = `[${name}] ${safeMsg}`;
      const command = `git commit --author="${name} <${email}>" -m "${commitMsg}"`;

      try {
        execSync(command, { stdio: 'inherit' });
      } catch (err) {
        console.error(`\n❌ Git commit failed:\n${err.message}`);
      }
    });
  }
};
