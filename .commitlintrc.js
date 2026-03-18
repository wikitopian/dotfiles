module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    // 2 means "error", "never" means it must NOT be empty
    'references-empty': [process.env.COMMITLINT_IGNORE_REFERENCES === '1' ? 0 : 2, 'never'],
  },
  parserPreset: {
    parserOpts: {
      // This regex tells commitlint what an issue reference looks like
      issuePrefixes: ['#']
    }
  }
};
