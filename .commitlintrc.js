module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    // 2 means "error", "never" means it must NOT be empty
    'references-empty': [process.env.COMMITLINT_IGNORE_REFERENCES === '1' ? 0 : 2, 'never'],
  },
  parserPreset: {
    parserOpts: {
      // This regex tells commitlint what an issue reference looks like
      issuePrefixes: ['#'],
      // Disable action-keyword parsing (fix, resolve, close) that swallows
      // references when these words appear adjacent to #NNN in the subject
      referenceActions: null,
      // Accept the Conventional Commits `!` breaking-change marker
      // (`feat!:`, `feat(scope)!:`); config-conventional's default parser omits
      // it, which made `feat!:` parse as an empty type.
      headerPattern: /^(\w*)(?:\(([\w$.\-*/ ]*)\))?!?: (.*)$/,
      headerCorrespondence: ['type', 'scope', 'subject']
    }
  }
};
