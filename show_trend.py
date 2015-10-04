#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#  2015 giulio <giulioungaretti@me.com>
"""
Show the trend over the year for the given word
Usage:
    main.py [--path=<path>] --word=<word>

Options:
    --h --help       show help
    [--path=<path>]   data file path(picke dic), defaults to ./data/all.pkl
    --word=<word>    word to show the trend for
"""
import pandas as pd
import matplotlib.pyplot as plt
import docopt
import pickle
plt.style.use('ggplot')


def get_word(counts, word):
    global ax
    res = {}
    for y in counts:
        dt = counts[y]
        for item in dt:
            if item[0] == word:
                res[int(y[:4])] = int(item[1])
    df = pd.DataFrame.from_dict(res, orient="index")
    df.columns = [word]
    df.sort().plot(label=word)
    return df

pkl_file = open('./data/all.pkl', 'rb')
mydict2 = pickle.load(pkl_file)
pkl_file.close()

if __name__ == '__main__':
    args = docopt.docopt(__doc__)
    path = args.get("--path")
    word = args.get("--word")
    ballet = get_word(mydict2, word)
    plt.show()
# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4
# vim: filetype=python foldmethod=indent
