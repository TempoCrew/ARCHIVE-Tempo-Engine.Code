package engine.backend.macro;

#if !display
class GitCommitMacro
{
	/**
	 * Get the SHA1 hash of the current Git commit.
	 */
	public static macro function getGitCommitHash():haxe.macro.Expr.ExprOf<String>
	{
		#if !display
		final pos = haxe.macro.Context.currentPos();
		final process = new sys.io.Process('git', ['rev-parse', 'HEAD']);

		if (process.exitCode() != 0)
			haxe.macro.Context.info('[WARN] Could not determine current git commit; is this a proper Git repository?', pos);

		final commitHash:String = process.stdout.readLine();
		final commitHashSplice:String = commitHash.substr(0, 7);

		#if FEATURE_GIT_TRACE
		Sys.println('Git Commit ID: ${commitHashSplice}');
		#end

		return macro $v{commitHashSplice};
		#else
		final commitHash:String = "";
		return macro $v{commitHashSplice};
		#end
	}

	/**
	 * Get the branch name of the current Git commit.
	 */
	public static macro function getGitBranch():haxe.macro.Expr.ExprOf<String>
	{
		#if !display
		final pos = haxe.macro.Context.currentPos();
		final branchProcess = new sys.io.Process('git', ['rev-parse', '--abbrev-ref', 'HEAD']);

		if (branchProcess.exitCode() != 0)
			haxe.macro.Context.info('[WARN] Could not determine current git commit; is this a proper Git repository?', pos);

		final branchName:String = branchProcess.stdout.readLine();

		#if FEATURE_GIT_TRACE
		Sys.println('Git Branch Name: ${branchName}\n');
		#end

		return macro $v{branchName};
		#else
		final branchName:String = "";
		return macro $v{branchName};
		#end
	}

	/**
	 * Get whether the local Git repository is dirty or not.
	 */
	public static macro function getGitHasLocalChanges():haxe.macro.Expr.ExprOf<Bool>
	{
		#if !display
		final pos = haxe.macro.Context.currentPos();
		final branchProcess = new sys.io.Process('git', ['status', '--porcelain']);

		if (branchProcess.exitCode() != 0)
			haxe.macro.Context.info('[WARN] Could not determine current git commit; is this a proper Git repository?', pos);

		var output:String = '';

		try
			output = branchProcess.stdout.readLine()
		catch (e)
			if (e.message != 'Eof')
				throw e;

		#if FEATURE_GIT_TRACE
		Sys.println('Git Status Output: ${output}');
		#end

		return macro $v{output.length > 0};
		#else
		return macro $v{true};
		#end
	}
}
#end
