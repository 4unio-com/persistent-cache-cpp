/*
 * Copyright (C) 2015 Canonical Ltd.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authored by: Michi Henning <michi.henning@canonical.com>
 */

#include <core/persistent_string_cache.h>

#include <iostream>
#include <sstream>
#include <string>

using namespace std;

#define DB_NAME "string_db"

int main(int /* argc */, char** /* argv */)
{
    system("rm -fr " DB_NAME);

    auto c = core::PersistentStringCache::open(DB_NAME, 1024 * 1024 * 1024, core::CacheDiscardPolicy::lru_only);

    string bjarne = "Bjarne Stroustrup";
    c->put(bjarne, "C++ inventor");
    auto value = c->get(bjarne);
    if (value)
    {
        cout << bjarne << ": " << *value << endl;
    }
    string person = "no such person";
    value = c->get(person);
    assert(!value);
}
